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

    // Redux setup
    this.store = jobTypeStore;
    this.unsubscribe = this.store.subscribe(() => {
      this.setState(Object.assign({}, this.state, this.store.getState()))
    });

    // State
    this.state = this.store.getState();
  }

  componentWillMount() {
    if (this.props.id) {
      Api.getJobType(this.props.id, data => (
        this.store.dispatch({type: JobTypeAction.updated, data: data})
      ));
      return;
    }
    this.setState({data: null});
  }

  footer() {
    if (this.state.showPicker) {
      return (
        <PluginPicker categoryPath="root" data={this.state.data} onSelection={this.subcomponentDidUpdateData.bind(this)}/>
      );
    }
    return (
      <AddStepButton onClick={() => (
        this.store.dispatch({type: JobTypeAction.showPicker})
      )}/>
    );
  }

  subcomponentDidUpdateData(data) {
    this.setState({data: data})
  }

  render() {
    step_types = this.state.data ? this.state.data.step_types : [];
    return (
      <div>
        <JobTypeDescription data={this.state.data} editable={this.props.editable} onChange={this.subcomponentDidUpdateData.bind(this)}/>
        { step_types.map(step_type => (
          <StepType key={step_type.id} data={step_type} jobTypeId={this.state.data.id} onChange={this.subcomponentDidUpdateData.bind(this)}/>
        )) }
        { this.footer() }
      </div>
    );
  }
}

JobTypeForm.propTypes = {
  id: React.PropTypes.any,
  editable: React.PropTypes.bool
};
