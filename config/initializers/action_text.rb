# Lexxy's engine assigns ActionText::ContentHelper.allowed_tags inside an
# ActiveSupport.on_load(:action_text_content) hook, so our additions have to use
# the same hook. App initializers are registered after engine initializers, so
# this one runs second and keeps Lexxy's additions.
#
# Lexical exports strikethrough as <s> and underline as <u>, and neither is in
# Rails' default safe list nor in Lexxy's additions. Without this they are
# silently stripped on render.
ActiveSupport.on_load(:action_text_content) do
  helper = Class.new { include ActionText::ContentHelper }.new

  ActionText::ContentHelper.allowed_tags = helper.sanitizer_allowed_tags | ["s", "u"]

  # Rails' safe list has neither target nor rel, so a link opened in a new tab
  # loses both -- including the rel="noopener" that makes target="_blank" safe.
  ActionText::ContentHelper.allowed_attributes =
    helper.sanitizer_allowed_attributes | ["target", "rel"]
end
