class StepType extends React.Component {
  constructor() {
    super();
    this.state = {
      data: null
    };
    this.fields = {};
  }

  buttons() {
    const saveOnClick = () => {
      Api.updateStepType(this.props.jobTypeId, this.props.data.id, this.fields, this.props.onChange)
    };
    const removeOnClick = () => {
      Api.deleteStepType(this.props.jobTypeId, this.props.data.id, this.props.onChange)
    };
    return (
      <div className="btn-group btn-group-xs pull-right">
        <button type="button" className="btn btn-xs btn-default" onClick={saveOnClick}>
          <i className="glyphicon glyphicon-floppy-disk"></i> { I18n.t("job_types.step_types.save") }
        </button>
        <button type="button" className="btn btn-xs btn-default" onClick={removeOnClick}>
          <i className="glyphicon glyphicon-trash"></i> { I18n.t("job_types.step_types.remove") }
        </button>
      </div>
    );
  }

  render() {
    return (
      <JoaquinPanel title={this.props.data.plugin.name} button={this.buttons()}>
        <div className="panel-body">
          { this.props.data.plugin.fields.map(field => (
            <JoaquinField
              key={field.id}
              type={field.type}
              title={field.name}
              description={field.description}
              value={this.props.data.plugin.data[field.id] || field.default_value}
              onChange={event => (
                this.fields = Object.assign(this.fields, {[field.id]: event.target.value})
              )}
            />
          )) }
        </div>
      </JoaquinPanel>
    );
  }
}

StepType.propTypes = {
  jobTypeId: React.PropTypes.any,
  data: React.PropTypes.any,
  onChange: React.PropTypes.any
};
