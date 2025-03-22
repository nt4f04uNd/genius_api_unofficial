import 'dart:math';

import 'package:webdriver/async_io.dart';
import 'dart:async';

import 'auth_redirect_data.dart';
import 'auth_token_manager.dart';

Future<AuthRedirectData> authorizeWithSelenium(
  String email,
  String password,
  Uri authUri,
) async {
  const userAgentList = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36'
  ];

  final randomUserAgent =
      userAgentList[(Random().nextDouble() * userAgentList.length).toInt()];

  // Configure WebDriver with headless Chrome
  final asyncDriver = await createDriver(
    uri: Uri.parse('http://localhost:9515'),
    desired: {
      'browserName': 'chrome',
      'goog:chromeOptions': {
        'args': [
          '--headless',
          '--disable-blink-features=AutomationControlled',
          '--user-agent=$randomUserAgent',
        ]
      }
    },
  );
  final driver = asyncDriver.syncDriver;

  AuthRedirectData? authRedirectData;
  try {
    // Open login page
    driver.get('https://genius.com/signup_or_login');

    // Close cookie banner
    try {
      final acceptCookieButton =
          driver.findElement(const By.id('onetrust-accept-btn-handler'));
      acceptCookieButton.click();
      print('Cookie banner successfully closed');
    } catch (e) {
      print('Cookie banner not found');
    }

    // Find the login button by text and click it
    final loginButton =
        driver.findElement(const By.cssSelector('[data-target=".log_in_tab"]'));
    loginButton.click();

    // Find the email input field and enter email
    final emailField = driver.findElement(const By.id('user_session_login'));
    emailField.sendKeys(email);

    // Find the password input field and enter password
    final passwordField =
        driver.findElement(const By.id('user_session_password'));
    passwordField.sendKeys(password);

    // Submit the login form (press Enter)
    passwordField.sendKeys('\n');

    // Wait for a successful login (adjust time as needed)
    await Future.delayed(const Duration(seconds: 3));

    // Print the current URL after login
    print('Logged in!');
    print("Redirect: ${Uri.parse(driver.currentUrl).stripPrivateInfo}");

    // Open the target URL
    driver.get(authUri);

    print("Redirect: ${Uri.parse(driver.currentUrl).stripPrivateInfo}");

    // Wait for and click the 'Approve' button
    final approveButton = driver
        .findElement(By.cssSelector('input[name="approve"][type="submit"]'));
    approveButton.click();
    print("Clicked Approve button.");

    // Wait for the URL to change (redirect detection)
    Future.delayed(Duration(seconds: 1));
    print("Redirect: ${Uri.parse(driver.currentUrl).stripPrivateInfo}");

    authRedirectData = AuthRedirectData.parseFromUri(Uri.parse(
      driver.currentUrl,
    ));
    return authRedirectData;
  } finally {
    driver.quit();
    if (authRedirectData != null) {
      AuthRedirectDataManager().save(authRedirectData);
    }
  }
}

extension on Uri {
  Uri get stripPrivateInfo => Uri(
        scheme: scheme,
        host: host,
        path: path,
      );
}
