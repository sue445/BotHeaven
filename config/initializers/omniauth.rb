Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, Rails.application.secrets.slack_app_id, Rails.application.secrets.slack_app_secret, {
    scope: 'client',
    team: Rails.application.secrets.slack_team_id
  }
end
