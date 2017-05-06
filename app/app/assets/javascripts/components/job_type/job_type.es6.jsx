class AddStepButton extends React.Component {
  render() {
    return (
      <button type="button" className="btn btn-default btn-block" onClick={this.props.onClick}>
        { I18n.t('job_types.plugins.add_step_button') }
      </button>
    );
  }
}

AddStepButton.propTypes = {
  onClick: React.PropTypes.any
};

class JobTypeForm extends React.Component {
  constructor() {
    super();
    this.state = {
      showPicker: false,
      steps: []
    };
  }

  footer() {
    if (this.state.showPicker || this.state.steps.length == 0) {
      return (
        <PluginPicker categoryPath="root"/>
      );
    }
    return (
      <AddStepButton onClick={() => {
        this.setState({showPicker: true, steps: this.state.steps});
      }}/>
    );
  }

  render() {
    return (
      <div>
        { this.footer() }
      </div>
    );
  }
}

JobType.propTypes = {
  id: React.PropTypes.any
};
