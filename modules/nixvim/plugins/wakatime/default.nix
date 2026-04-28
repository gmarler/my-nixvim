{ config, ... }:
{
  # vim-wakatime documentation
  # See: https://github.com/wakatime/vim-wakatime
  plugins.wakatime.enable =
    config.gmarlervim.integrations.accountBacked.enable
    && config.gmarlervim.integrations.accountBacked.timeTracking.enable;
}
