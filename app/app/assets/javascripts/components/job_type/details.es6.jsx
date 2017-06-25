class JobTypeDetails extends JobTypeComponent {
  updateName(name) {
    if (!name || name.length == 0) {
      return;
    }

    Api.updateJobType(this.state.data.id, name, data => {
      this.store.dispatch({type: JobTypeAction.updated, data: data})
    });
  }

  createJob(name) {
    if (!name || name.length == 0) {
      return;
    }

    Api.createJobType(name, data => {
      window.location.href = "/job_types/" + data.id;
    });
  }

  // Subcomponents

  saveDetailsButton() {
    const buttonName = this.state.data ? I18n.t("job_types.details.save") : I18n.t("job_types.details.create");
    const onClick = () => {
      const name = this.state.name;
      if (!this.state.data) {
        this.createJob(name);
        return;
      }

      this.updateName(name);
    };
    return (
      <JoaquinBarButton onClick={onClick} title={buttonName} icon="done"/>
    );
  }

  addStepButton() {
    if (this.state.data) {
      const onClick = () => {
        this.store.dispatch({type: JobTypeAction.showPicker})
      };
      const disabled = this.state.showPicker ? "disabled" : "";
      return (
        <JoaquinBottomButton
          title={I18n.t("job_types.details.add_step")}
          onClick={onClick}
          disabled={disabled}
        />
      );
    }

    return ( <small>{ I18n.t("job_types.details.empty_hint") }</small> );
  }

  render() {
    const name = this.state.name ? this.state.name : (this.state.data ? this.state.data.name : '');
    return (
      <JoaquinPanel title={I18n.t("job_types.details.title")} options={this.saveDetailsButton()}>
        <div className="panel-body">
          <JoaquinField
            type="string"
            editable={this.props.editable}
            title={I18n.t("job_types.details.name")}
            description={I18n.t("job_types.details.description")}
            value={name}
            onChange={event => (
              this.setState({name: event.target.value})
            )}
          />
        </div>
        <MUI.CardActions>
          { this.addStepButton() }
        </MUI.CardActions>
      </JoaquinPanel>
    );
  }
}

JobTypeDetails.propTypes = {
  store: PropTypes.any,
  editable: PropTypes.bool
};
