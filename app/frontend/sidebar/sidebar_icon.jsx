import React from 'react';
import PropTypes from 'prop-types';

const SidebarIcon = props => (
  <div className="col-xs-4">
    <a href={props.url}>
      <img
        src={props.icon}
        id={`${props.type}-icon`}
        className="img-circle img-responsive"
        width="128"
        height="128"
        alt={props.type}
      />
    </a>
  </div>
);

SidebarIcon.propTypes = {
  type: PropTypes.string.isRequired,
  url: PropTypes.string.isRequired,
  icon: PropTypes.node.isRequired
};

export default SidebarIcon;
