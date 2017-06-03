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

  saveDetailsButton() {
    const onClick = () => {
      console.log();
    };
    return (
      <button type="button" className="btn btn-xs btn-default pull-right" onClick={onClick}>
        <i className="glyphicon glyphicon-floppy-disk"></i> { I18n.t("job_types.details.save") }
      </button>
    );
  }

  addStepButton() {
    const onClick = () => {
      this.store.dispatch({type: JobTypeAction.showPicker})
    };
    const disabled = this.state.showPicker ? "disabled" : "";
    return (
      <button type="button" className={"btn btn-xs btn-default " + disabled} onClick={onClick}>
        <i className="glyphicon glyphicon-plus"></i> { I18n.t("job_types.details.add_step") }
      </button>
    );
  }

  render() {
    const name = this.state.data ? this.state.data.name : "";
    return (
      <JoaquinPanel title={I18n.t("job_types.details.title")} button={this.saveDetailsButton()}>
        <div className="panel-body">
          <JoaquinField
            type="string"
            editable={this.props.editable}
            title={I18n.t("job_types.details.name")}
            description={I18n.t("job_types.details.description")}
            value={name}
            onChange={event => (
              this.updateName(event.target.value)
            )}
          />
        </div>
        <div className="panel-footer">
          { this.addStepButton() }
        </div>
      </JoaquinPanel>
    );
  }
}

JobTypeDetails.propTypes = {
  store: React.PropTypes.any,
  editable: React.PropTypes.bool
};
