class PluginPickerEntry extends React.Component {
  render() {
    const data = this.props.data
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
  completion: React.PropTypes.any,
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
    this.retrieveCategory(this.props.categoryPath);
  }

  retrieveCategory(path) {
    const URL = '/step_types/category/' + path;
    fetch(URL).then(res => res.json()).then(json => {
      this.setState({category: json});
    });
  }

  render() {
    if (!this.state.category) {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            { I18n.t('job_types.plugins.title') }
          </div>
        </div>
      );
    }
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          { I18n.t('job_types.plugins.title') }
        </div>
        <div className="list-group">
          { this.state.category.subcategories.map(category => (
            <PluginPickerEntry data={category} type="category" onClick={() => {
              this.retrieveCategory(category.path);
            }} />
          )) }
          { this.state.category.plugins.map(plugin => (
            <PluginPickerEntry data={plugin} type="plugin" onClick={() => {
              console.log(plugin.path);
            }}/>
          )) }
        </div>
      </div>
    );
  }
}

PluginPicker.propTypes = {
  categoryPath: React.PropTypes.string
};