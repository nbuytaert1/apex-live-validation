function render(
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin in apex_plugin.t_plugin
) return apex_plugin.t_dynamic_action_render_result is
  l_validation varchar2(4000) := p_dynamic_action.attribute_01;
  l_item_type varchar2(4000) := p_dynamic_action.attribute_02;
  l_items_to_validate varchar2(4000) := p_dynamic_action.attribute_03;
  l_triggering_event varchar2(4000) := p_dynamic_action.attribute_04;
  l_condition varchar2(4000) := p_dynamic_action.attribute_05;
  l_equal varchar2(4000) := p_dynamic_action.attribute_06;
  l_regex varchar2(4000) := p_dynamic_action.attribute_07;
  l_minimum_item varchar2(4000) := p_dynamic_action.attribute_08;
  l_maximum_item varchar2(4000) := p_dynamic_action.attribute_09;
  l_minimum varchar2(4000) := p_dynamic_action.attribute_10;
  l_maximum varchar2(4000) := p_dynamic_action.attribute_11;
  l_forms_to_validate varchar2(4000) := p_dynamic_action.attribute_12;
  l_form_submit_elements varchar2(4000) := p_dynamic_action.attribute_13;
  l_error_msg varchar2(4000) := p_dynamic_action.attribute_14;
  l_error_msg_location varchar2(4000) := p_dynamic_action.attribute_15;

  l_date_format varchar2(4000);
  l_numeric_characters varchar2(4000);

  l_result apex_plugin.t_dynamic_action_render_result;
begin
  select value
  into l_date_format
  from nls_session_parameters
  where parameter = 'NLS_DATE_FORMAT';

  select value
  into l_numeric_characters
  from nls_session_parameters
  where parameter = 'NLS_NUMERIC_CHARACTERS';

  l_result.attribute_01 := l_validation;
  l_result.attribute_02 := apex_plugin_util.page_item_names_to_jquery(l_items_to_validate);
  l_result.attribute_03 := l_triggering_event;
  l_result.attribute_04 := l_condition;
  l_result.attribute_05 := l_forms_to_validate;
  l_result.attribute_06 := l_item_type;
  l_result.attribute_07 := l_form_submit_elements;
  if l_minimum_item is not null then
    l_minimum_item := apex_plugin_util.page_item_names_to_jquery(l_minimum_item);
  end if;
  if l_maximum_item is not null then
    l_maximum_item := apex_plugin_util.page_item_names_to_jquery(l_maximum_item);
  end if;
  l_result.attribute_10 := nvl(l_minimum_item, l_minimum);
  l_result.attribute_11 := nvl(l_maximum_item, l_maximum);
  l_result.attribute_12 := apex_plugin_util.page_item_names_to_jquery(l_equal);
  l_result.attribute_13 := l_regex;
  l_result.attribute_14 := l_error_msg;
  l_result.attribute_15 := l_error_msg_location;

  l_result.javascript_function := '
    function() {
      var render = this;
      var action = render.action;
      var l_allowWhitespace = true;

      if (!action.attribute14) { action.attribute14 = ""; }

      if (action.attribute01 !== "form") {
        // item validation
        if (action.attribute01 === "notBlank") {
          action.attribute01 = "notEmpty";
          l_allowWhitespace = false;
        }
        if (!action.attribute04) { action.attribute04 = ""; }
        if (!action.attribute10) { action.attribute10 = ""; }
        if (!action.attribute11) { action.attribute11 = ""; }

        $(action.attribute02).alv({
          validate: action.attribute01,
          triggeringEvent: action.attribute03,
          condition: action.attribute04,
          errorMsg: action.attribute14,
          errorMsgLocation: action.attribute15,
          allowWhitespace: l_allowWhitespace,
          itemType: action.attribute06,
          dateFormat: "' || l_date_format || '",
          numericCharacters: "' || l_numeric_characters || '",
          min: action.attribute10,
          max: action.attribute11,
          equal: action.attribute12,
          regex: action.attribute13
        });
      } else {
        // form validation
        $(action.attribute07).alv("validateForm", {
          formsToSubmit: action.attribute05,
          errorMsg: action.attribute14
        });
      }
    }
  ';

  return l_result;
end render;