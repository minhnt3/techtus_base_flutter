import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

extension AnalyticsHelperOnRegisterPage on AnalyticsHelper {
  void _logRegisterButtonClickEvent() {
    logEvent(
      NormalEvent(
        screenName: ScreenName.register,
        eventName: EventConstants.registerButtonClick,
      ),
    );
  }

  void _logLoginButtonClickEvent() {
    logEvent(
      NormalEvent(
        screenName: ScreenName.register,
        eventName: EventConstants.loginButtonClick,
      ),
    );
  }

  void _logEyeIconClickEvent({
    required bool obscureText,
  }) {
    logEvent(
      NormalEvent(
        screenName: ScreenName.register,
        eventName: EventConstants.eyeIconClick,
        parameter: ObscureTextParameter(
          obscureText: obscureText,
        ),
      ),
    );
  }
}

@RoutePage()
class RegisterPage extends BasePage<RegisterState,
    AutoDisposeStateNotifierProvider<RegisterViewModel, CommonState<RegisterState>>> {
  const RegisterPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.register);

  @override
  AutoDisposeStateNotifierProvider<RegisterViewModel, CommonState<RegisterState>> get provider =>
      registerViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer(
              builder: (context, ref, child) => CommonImage.asset(
                path: ref.watch(backgroundProvider),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.rps),
              // ignore: missing_expanded_or_flexible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100.rps),
                  CommonText(
                    l10n.createAnAccount,
                    style: style(
                      fontSize: 30.rps,
                      fontWeight: FontWeight.w700,
                      color: color.black,
                    ),
                  ),
                  SizedBox(height: 50.rps),
                  PrimaryTextField(
                    title: l10n.email,
                    hintText: l10n.email,
                    onChanged: (email) => ref.read(provider.notifier).setEmail(email),
                    keyboardType: TextInputType.text,
                    suffixIcon: const Icon(Icons.email),
                  ),
                  SizedBox(height: 24.rps),
                  PrimaryTextField(
                    title: l10n.password,
                    hintText: l10n.password,
                    onChanged: (password) =>
                        ref.read(provider.notifier).setPassword(password.trim()),
                    keyboardType: TextInputType.visiblePassword,
                    onEyeIconPressed: (obscureText) {
                      ref.analyticsHelper._logEyeIconClickEvent(obscureText: obscureText);
                    },
                  ),
                  SizedBox(height: 24.rps),
                  PrimaryTextField(
                    title: l10n.passwordConfirmation,
                    hintText: l10n.passwordConfirmation,
                    onChanged: (password) =>
                        ref.read(provider.notifier).setConfirmPassword(password.trim()),
                    keyboardType: TextInputType.visiblePassword,
                    onEyeIconPressed: (obscureText) {
                      ref.analyticsHelper._logEyeIconClickEvent(obscureText: obscureText);
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final onPageError = ref.watch(
                        provider.select(
                          (value) => value.data.onPageError,
                        ),
                      );

                      return Visibility(
                        visible: onPageError.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.rps),
                          child: CommonText(
                            onPageError,
                            style: style(
                              fontSize: 14.rps,
                              color: color.red1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.rps),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    // ignore: missing_expanded_or_flexible
                    child: Row(
                      children: [
                        CommonText(
                          onTap: () => ref.read(appNavigatorProvider).pop(),
                          l10n.alreadyHaveAnAccount,
                          style: style(
                            fontSize: 18.rps,
                            color: color.black,
                          ),
                        ),
                        CommonText(
                          onTap: () {
                            ref.analyticsHelper._logLoginButtonClickEvent();
                            ref.read(appNavigatorProvider).pop();
                          },
                          l10n.login,
                          style: style(
                            fontSize: 18.rps,
                            fontWeight: FontWeight.bold,
                            color: color.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.rps),
                  Consumer(
                    builder: (context, ref, child) {
                      final isRegisterButtonEnabled = ref.watch(provider.select(
                        (value) => value.data.isRegisterButtonEnabled,
                      ));

                      return ElevatedButton(
                        onPressed: isRegisterButtonEnabled
                            ? () {
                                ref.analyticsHelper._logRegisterButtonClickEvent();
                                ref.read(provider.notifier).register();
                              }
                            : null,
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 48.rps),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            color.black.withOpacity(isRegisterButtonEnabled ? 1 : 0.5),
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.rps)),
                            ),
                          ),
                        ),
                        child: CommonText(
                          l10n.createAnAccount,
                          style: style(
                            fontSize: 18.rps,
                            fontWeight: FontWeight.bold,
                            color: color.white,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.rps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
