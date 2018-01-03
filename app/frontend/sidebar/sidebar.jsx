import React from 'react';
import ReactDOM from 'react-dom';

import GithubLogo from 'images/social/github-128.png';
import LinkedInLogo from 'images/social/linkedin-128.png';
import TwitterLogo from 'images/social/twitter-128.png';
import MyPicture from 'images/me.jpg';
import SidebarIcon from './sidebar_icon';

const Sidebar = () => (
  <div>
    <div id="sidebar-images">
      <img src={MyPicture} className="img-circle img-responsive" alt="t27duck" />
      <div id="social-icons" className="row">
        <SidebarIcon type="github" url="https://github.com/t27duck" icon={GithubLogo} />
        <SidebarIcon type="linkedin" url="https://linkedin.com/in/t27duck" icon={LinkedInLogo} />
        <SidebarIcon type="twitter" url="https://twitter.com/t27duck" icon={TwitterLogo} />
      </div>
    </div>
    <div className="panel">
      <div className="panel-body">
        I am Tony Drake - Professional web developer, geek, and Mario Kart connoisseur.
        This site is where I put my ramblings and talk about my interests.
      </div>
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Sidebar />,
    document.getElementById('sidebar'),
  );
});
