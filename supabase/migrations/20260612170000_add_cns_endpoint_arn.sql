-- Push delivery moves to Yandex Cloud Notification Service (CNS,
-- SNS-compatible API at notifications.yandexcloud.net). Each device token
-- is lazily registered as a CNS platform endpoint; the resulting ARN is
-- cached here so Publish calls skip re-registration.
-- Applied remotely as: add_cns_endpoint_arn.

alter table core.user_devices add column cns_endpoint_arn text;
