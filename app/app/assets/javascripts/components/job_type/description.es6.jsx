class JobTypeDescription extends React.Component {
  updateName(name) {
    if (!name || name.length == 0) {
      return;
    }

    if (!this.props.data) {
      Api.createJobType(name, data => {
        this.props.data = data;
        this.props.completion(data);
      });
      return;
    }

    Api.updateJobType(this.props.data.id, name, data => {
      this.props.data = data;
      this.props.completion(data);
    });
  }

  render() {
    const name = this.props.data ? this.props.data.name : "";
    return (
      <div>
        <JoaquinField type="string" editable={this.props.editable} title={I18n.t("job_types.description.name")} description={I18n.t("job_types.description.description")} value={name} onChange={event => (
          this.updateName(event.target.value)
        ).bind(this)} />
      </div>
    );
  }
}

JobTypeDescription.propTypes = {
  data: React.PropTypes.any,
  editable: React.PropTypes.bool,
  onChange: React.PropTypes.any
};
