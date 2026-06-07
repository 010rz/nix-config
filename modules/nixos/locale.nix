{ myvars, ... }:
{
  time.timeZone = myvars.timezone;
  i18n.defaultLocale = myvars.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = myvars.locale;
    LC_IDENTIFICATION = myvars.locale;
    LC_MEASUREMENT = myvars.locale;
    LC_MONETARY = myvars.locale;
    LC_NAME = myvars.locale;
    LC_NUMERIC = myvars.locale;
    LC_PAPER = myvars.locale;
    LC_TELEPHONE = myvars.locale;
    LC_TIME = myvars.locale;
  };
}
