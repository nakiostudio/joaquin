class PluginPicker extends React.Component {
  constructor() {
    super();
    this.state = {
      category: null
    };
  }

  componentDidMount() {
    const URL = '/step_types/category/' + this.props.categoryPath;
    fetch(URL).then(res => res.json()).then(json => {
      this.setState({category: json});
    });
  }

  render() {
    if (!this.state.category) {
      return <div></div>;
    }
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          { I18n.t('job_types.plugins.title') }
        </div>
        <div className="list-group">
          { this.state.category.subcategories.map((category, index) => (
            <a className="list-group-item row-category" data-path="{ category.path }" href="#"><strong>{ category.name }</strong> <span className="glyphicon glyphicon-menu-right pull-right" aria-hidden="true"></span></a>
          )) }
          { this.state.category.plugins.map((plugin, index) => (
            <a className="list-group-item row-plugin" href="#">{ plugin }</a>
          )) }
        </div>
      </div>
    );
  }
}

PluginPicker.propTypes = {
  categoryPath: React.PropTypes.string
};
