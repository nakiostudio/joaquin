module Joaquin

  STATUS_UNSTARTED    = 'unstarted'
  STATUS_STARTED      = 'started'
  STATUS_SUCCESSFUL   = 'successful'
  STATUS_FAILED       = 'failed'
  STATUS_CANCELLED    = 'cancelled'

  JOB_TYPE_CRON       = 'cron'
  JOB_TYPE_REGULAR    = 'regular'

  LOG_TYPE_OUTPUT     = 'output'
  LOG_TYPE_ERROR      = 'error'

  PRINT_TYPE_DEBUG    = 'DEBUG'
  PRINT_TYPE_INFO     = 'INFO '
  PRINT_TYPE_ERROR    = 'ERROR'

  NODE_ENDPOINT_REGISTER_NODE       = '/node_api/node/register'
  NODE_ENDPOINT_SUBMIT_JOB_UPDATE   = '/node_api/job/update'
  NODE_ENDPOINT_SUBMIT_STEP_UPDATE  = '/node_api/step/update'
  NODE_ENDPOINT_SUBMIT_STEP_LOG     = '/node_api/step/log'

  SERVER_ENDPOINT_NODE_STATUS       = '/server_api/node/status'
  SERVER_ENDPOINT_ENQUEUE_JOB       = '/server_api/job/enqueue'
  SERVER_ENDPOINT_CANCEL_JOB        = '/server_api/job/cancel'

end
