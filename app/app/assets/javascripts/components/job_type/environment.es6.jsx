class JobTypeEnvironmentEntry extends React.Component {
  render() {
    return (
      <div className="row">
        <div className="col-md-6">
          <JoaquinField title={ I18n.t("job_types.environment.entry.key") } type="string" />
        </div>
      <div className="col-md-6">
          <JoaquinField title={ I18n.t("job_types.environment.entry.value") } type="string" />
        </div>
      </div>
    );
  }
}

class JobTypeEnvironment extends React.Component {
  constructor() {
    super();
    this.state = {
      environment_variables: this.props.environment_variables ? this.props.environment_variables  : [{},{}]
    };
  }

  body() {
    if (this.state.environment_variables.length > 0) {
      return (
        <label>No environment variables have been defined</label>
      );
    }
    return (
      <div>
        { this.state.environment_variables.map(variable => (
          <JobTypeEnvironmentEntry/>
        )) }
      </div>
    );
  }

  render() {
    const title = I18n.t("job_types.environment.title");
    return (
      <JoaquinPanel title={title}>
        { this.body() }
      </JoaquinPanel>
    );
  }
}

JobTypeEnvironment.propTypes = {
  environment_variables: React.PropTypes.any
};
