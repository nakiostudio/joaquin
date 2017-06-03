class Api {

  // Plugins

  static retrievePluginsCategory(path, completion) {
    Api.request('/plugins/' + path, 'GET', null)
      .then(res => res.json())
      .then(completion);
  }

  // Job types

  static createJobType(name, completion) {
    Api.request('/job_types', 'POST', { name: name })
      .then(res => res.json())
      .then(completion);
  }

  static updateJobType(id, name, completion) {
    Api.request('/job_types/' + id, 'PUT', { name: name })
      .then(res => res.json())
      .then(completion);
  }

  static getJobType(id, completion) {
    Api.request('/job_types/' + id, 'GET', null)
      .then(res => res.json())
      .then(completion)
  }

  static createStepType(jobTypeId, pluginPath, completion) {
    parameters = { plugin_path: pluginPath };
    Api.request('/job_types/' + jobTypeId + '/step_types', 'POST', parameters)
      .then(res => res.json())
      .then(completion)
  }

  static updateStepType(jobTypeId, stepTypeId, fields, completion) {
    parameters = { plugin_data: fields };
    Api.request('/job_types/' + jobTypeId + '/step_types/' + stepTypeId, 'PUT', parameters)
      .then(res => res.json())
      .then(completion)
  }

  static deleteStepType(jobTypeId, stepTypeId, completion) {
    Api.request('/job_types/' + jobTypeId + '/step_types/' + stepTypeId, 'DELETE', null)
      .then(res => res.json())
      .then(completion)
  }

  // Helpers

  static request(url, method, body) {
    details = {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    };
    if (body) {
      details.body = JSON.stringify(body);
    }
    return fetch(url, details);
  }
}
