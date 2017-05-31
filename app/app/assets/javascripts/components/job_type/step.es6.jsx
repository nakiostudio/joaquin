class StepType extends React.Component {
  constructor() {
    super();
    this.state = {
      data: null
    };
  }

  componentDidMount() {
    this.setState({data: this.props.data});
  }

  deleteStepButton() {
    const onClick = () => {
      Api.deleteStepType(this.props.jobTypeId, this.state.data.id, this.props.onChange)
    }
    return (
      <button type="button" className="btn btn-xs btn-default pull-right" onClick={onClick}>
        <i className="glyphicon glyphicon-trash"></i> { I18n.t("job_types.step_types.remove") }
      </button>
    );
  }

  render() {
    if (!this.state.data) {
      return null;
    }
    return (
      <JoaquinPanel title={this.state.data.plugin.name} button={this.deleteStepButton()}>
        <div className="panel-body">
          { this.state.data.plugin.fields.map(field => (
            <JoaquinField
              key={field.id}
              type={field.type}
              title={field.name}
              description={field.description}
              value={field.default_value}
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

