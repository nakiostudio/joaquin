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
  data: React.PropTypes.any,
  type: React.PropTypes.string,
  onClick: React.PropTypes.any
};

class PluginPicker extends React.Component {
  constructor() {
    super();
    this.state = {
      category: null
    };
  }

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
            Api.createStepType(this.props.data.id, plugin.path, this.props.onSelection)
          }.bind(this)}/>
        )) }
      </div>
    );
  }

  render() {
    return (
      <div className="row">
        <div className="col-md-6">
          <label>{ I18n.t('job_types.plugins.help.title') }</label>
          <p>{ I18n.t('job_types.plugins.help.message') }</p>
        </div>
        <div className="col-md-6">
          <JoaquinPanel title={ I18n.t("job_types.plugins.title") }>
            { this.pickerBody() }
          </JoaquinPanel>
        </div>
      </div>
    );
  }
}

PluginPicker.propTypes = {
  data: React.PropTypes.any,
  categoryPath: React.PropTypes.string,
  onSelection: React.PropTypes.any
};
