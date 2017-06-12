class PluginPickerEntry extends React.Component {
  render() {
    const data = this.props.data;
    const style = { 'cursor': 'pointer' };
    if (this.props.type == 'plugin') {
      return (
        <a className="list-group-item row-plugin" style={style} key={data.path} onClick={this.props.onClick}>{ data.name }</a>
      );
    }
    return (
      <a className="list-group-item row-category" style={style} key={data.path} onClick={this.props.onClick}>
        <strong>{ data.name }</strong> <span className="glyphicon glyphicon-menu-right pull-right" aria-hidden="true"></span>
      </a>
    );
  }
}

PluginPickerEntry.propTypes = {
  data: PropTypes.any,
  type: PropTypes.string,
  onClick: PropTypes.any
};

class PluginPicker extends JobTypeComponent {
  componentDidMount() {
    Api.retrievePluginsCategory(this.props.categoryPath, json => (
      this.setState({category: json})
    ));
  }

  pickerBody() {
    if (!this.state.category) {
      return (
        <div className="list-group"></div>
      );
    }
    return (
      <div className="list-group">
        { this.state.category.subcategories.map(category => (
          <PluginPickerEntry key={category.path} data={category} type="category" onClick={() => {
            Api.retrievePluginsCategory(category.path, json => (
              this.setState({category: json})
            ));
          }.bind(this)} />
        )) }
        { this.state.category.plugins.map(plugin => (
          <PluginPickerEntry key={plugin.path} data={plugin} type="plugin" onClick={() => {
            Api.createStepType(this.state.data.id, plugin.path, data => {
              this.store.dispatch({type: JobTypeAction.updated, data: data});
              this.store.dispatch({type: JobTypeAction.hidePicker});
            });
          }.bind(this)}/>
        )) }
      </div>
    );
  }

  render() {
    const onCloseButtonClick = () => (
      this.store.dispatch({type: JobTypeAction.hidePicker})
    );
    const closeButton = (
      <JoaquinBarButton title={I18n.t("job_types.plugins.close")} icon="clear" onClick={onCloseButtonClick}/>
    );
    return (
      <JoaquinPanel className="row" title={ I18n.t("job_types.plugins.title") } options={closeButton}>
        <div className="panel-body">
          <p>{ I18n.t('job_types.plugins.help') }</p>
        </div>
        { this.pickerBody() }
      </JoaquinPanel>
    );
  }
}

PluginPicker.propTypes = {
  store: PropTypes.any,
  categoryPath: PropTypes.string
};
