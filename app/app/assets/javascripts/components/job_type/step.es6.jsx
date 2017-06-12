class StepType extends React.Component {
  constructor(props) {
    super(props);

    this.fields = props.data.plugin.data;
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
        <JoaquinBarButton title={I18n.t("job_types.step_types.save")} icon="done" onClick={saveOnClick}/>
        <JoaquinBarButton title={I18n.t("job_types.step_types.remove")} icon="clear" onClick={removeOnClick}/>
      </div>
    );
  }

  render() {
    return (
      <JoaquinPanel title={this.props.data.plugin.name} options={this.buttons()}>
        <div className="panel-body">
          { this.props.data.plugin.fields.map(field => (
            <JoaquinField
              key={field.id}
              type={field.type}
              title={field.name}
              description={field.description}
              placeholder={field.placeholder}
              value={this.fields[field.id] || field.default_value}
              validators={field.validators}
              onChange={event => {
                this.fields = Object.assign(this.fields, {[field.id]: event.target.value});
              }}
            />
          )) }
          <br/>
        </div>
      </JoaquinPanel>
    );
  }
}

StepType.propTypes = {
  jobTypeId: PropTypes.any,
  data: PropTypes.any,
  onChange: PropTypes.any
};
