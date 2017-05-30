class JobTypeDetails extends JobTypeComponent {
  updateName(name) {
    if (!name || name.length == 0) {
      return;
    }

    this.store.dispatch({type: JobTypeAction.loading})

    if (!this.state.data) {
      Api.createJobType(name, data => {
        this.store.dispatch({type: JobTypeAction.updated, data: data})
      });
      return;
    }

    Api.updateJobType(this.state.data.id, name, data => {
      this.store.dispatch({type: JobTypeAction.updated, data: data})
    });
  }

  render() {
    const name = this.state.data ? this.state.data.name : "";
    return (
      <div>
        <JoaquinField
          type="string"
          editable={this.props.editable}
          title={I18n.t("job_types.description.name")}
          description={I18n.t("job_types.description.description")}
          value={name}
          onChange={event => (
            this.updateName(event.target.value)
          )}
        />
      </div>
    );
  }
}

JobTypeDetails.propTypes = {
  store: React.PropTypes.any,
  editable: React.PropTypes.bool
};
