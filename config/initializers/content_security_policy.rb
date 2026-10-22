# Be sure to restart your server when you modify this file.
#
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self
    policy.form_action :self
    policy.font_src    :self

    # Nothing here is meant to be embedded anywhere else.
    policy.frame_ancestors :none

    # Lexxy's sanitizer allows <embed> in rich text, but nothing uses one.
    policy.object_src :none

    # googletagmanager is gtag.js, only rendered when GA_TAG_ID is set.
    # ga.jspm.io is es-module-shims, the import map fallback for old browsers.
    # The disqus hosts are embed.js and the bundle it pulls in after itself --
    # the nonce on the inline loader in posts/show does not carry over to the
    # script element that loader creates, so the origins have to be named here.
    policy.script_src :self,
                      "https://www.googletagmanager.com",
                      "https://ga.jspm.io",
                      "https://t27duck.disqus.com",
                      "https://c.disquscdn.com"

    # unsafe-inline covers the two inline styles that cannot take a nonce: the
    # style="..." attributes Lexxy writes (the sanitizer keeps style on saved
    # content, and syntax highlighting calls setAttribute("style", ...)), and
    # the <style> element Turbo injects for the progress bar. Keep the nonce out
    # of style-src -- a nonce there makes browsers ignore unsafe-inline.
    # blob: is es-module-shims feature-detecting CSS modules; see connect-src.
    policy.style_src :self, :blob, :unsafe_inline

    # data: is the SVG icons in lexxy-editor.css. blob: is the local preview
    # Lexxy shows from URL.createObjectURL while an attachment uploads.
    policy.img_src :self, :data, :blob,
                   "https://www.googletagmanager.com",
                   "https://*.google-analytics.com",
                   "https://*.analytics.google.com",
                   "https://c.disquscdn.com",
                   "https://referrer.disqus.com"

    # :self is Active Storage direct uploads. blob: and ga.jspm.io are both
    # es-module-shims: it feature-detects on every page load by building a
    # srcdoc iframe and fetching a blob URL, and devtools fetches its source map
    # from the CDN. Neither reaches a reader, but without them the console logs
    # a violation per page view and drowns out anything real. The shim does not
    # need blob: in script-src, which is why that stays off. Rest are beacons.
    policy.connect_src :self, :blob,
                       "https://ga.jspm.io",
                       "https://www.googletagmanager.com",
                       "https://*.google-analytics.com",
                       "https://*.analytics.google.com"

    # YouTube for talk embeds, Disqus for the comment widget.
    policy.frame_src "https://www.youtube.com",
                     "https://disqus.com"
  end

  # Not request.session.id: a first-time visitor sends no session cookie, and
  # the read path never mints an id, so the nonce would come out empty and every
  # inline script would be blocked on the very first page view.
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }

  # script-src only. A nonce in style-src would make browsers ignore the
  # unsafe-inline that Lexxy and Turbo both depend on.
  config.content_security_policy_nonce_directives = ["script-src"]
end
