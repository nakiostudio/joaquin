class JobTypeForm extends JobTypeComponent {
  componentDidMount() {
    if (this.props.id) {
      Api.getJobType(this.props.id, data => (
        this.store.dispatch({type: JobTypeAction.updated, data: data})
      ));
      return;
    }
    this.store.dispatch({type: JobTypeAction.restart});
  }

  footer() {
    if (this.state.showPicker) {
      return (
        <PluginPicker store={this.store} categoryPath="root"/>
      );
    }
    return null;
  }

  stepDidUpdateData(data) {
    this.store.dispatch({type: JobTypeAction.updated, data: data})
  }

  render() {
    step_types = this.state.data ? this.state.data.step_types : [];
    return (
      <div>
        <JobTypeDetails editable={this.props.editable} store={this.store}/>
        { step_types.map(step_type => (
          <StepType key={step_type.id} data={step_type} jobTypeId={this.state.data.id} onChange={this.stepDidUpdateData.bind(this)}/>
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
