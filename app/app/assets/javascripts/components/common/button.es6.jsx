class JoaquinBarButton extends React.Component {
  render() {
    icon = null;
    if (this.props.icon) {
      icon = (
        <MUI.FontIcon className="material-icons">
          {this.props.icon}
        </MUI.FontIcon>
      );
    }
    return (
      <MUI.IconButton
        tooltip={this.props.title}
        disabled={this.props.disabled || false}
        iconStyle={{margin: 0, color: Colors.grey700}}
        hoveredStyle={{color: Colors.fullBlack}}
        onClick={this.props.onClick}
      >
        {icon}
      </MUI.IconButton>
    );
  }
}

JoaquinBarButton.propTypes = {
  onClick: PropTypes.any,
  title: PropTypes.string,
  icon: PropTypes.string,
  disabled: PropTypes.any
};

class JoaquinBottomButton extends React.Component {
  render() {
    return (
      <MUI.FlatButton
        onClick={this.props.onClick}
        label={this.props.title}
        backgroundColor={Colors.grey200}
        disabled={this.props.disabled || false}
      />
    );
  }
}

JoaquinBottomButton.propTypes = {
  onClick: PropTypes.any,
  title: PropTypes.string,
  disabled: PropTypes.any
};
