function render(p_dynamic_action in apex_plugin.t_dynamic_action
              , p_plugin         in apex_plugin.t_plugin)
return apex_plugin.t_dynamic_action_render_result is
  lco_jquery_id_selector  constant char := '#';
  lco_page_item_separator constant char := ',';

  l_validation           varchar2(4000) := p_dynamic_action.attribute_01;
  l_items_to_validate    varchar2(4000) := p_dynamic_action.attribute_02;
  l_triggering_event     varchar2(4000) := p_dynamic_action.attribute_03;
  l_condition            varchar2(4000) := p_dynamic_action.attribute_04;
  l_form_to_validate     varchar2(4000) := p_dynamic_action.attribute_05;
  l_item_type            varchar2(4000) := p_dynamic_action.attribute_06;
  l_form_submit_elements varchar2(4000) := p_dynamic_action.attribute_07;
  l_minimum_item         varchar2(4000) := p_dynamic_action.attribute_08;
  l_maximum_item         varchar2(4000) := p_dynamic_action.attribute_09;
  l_minimum              varchar2(4000) := p_dynamic_action.attribute_10;
  l_maximum              varchar2(4000) := p_dynamic_action.attribute_11;
  l_equal                varchar2(4000) := p_dynamic_action.attribute_12;
  l_regex                varchar2(4000) := p_dynamic_action.attribute_13;
  l_error_msg            varchar2(4000) := p_dynamic_action.attribute_14;
  l_error_msg_location   varchar2(4000) := p_dynamic_action.attribute_15;

  l_date_format varchar2(4000);
  l_tmp_items_to_validate apex_application_global.vc_arr2;

  l_render_result apex_plugin.t_dynamic_action_render_result;
begin
  apex_javascript.add_library(
    p_name      => 'jquery.alv',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );
  apex_css.add_file(
    p_name      => 'style.alv',
    p_directory => p_plugin.file_prefix,
    p_version   => null
  );

  select value
  into l_date_format
  from nls_session_parameters
  where parameter = 'NLS_DATE_FORMAT';

  if l_validation != 'form' then
    l_tmp_items_to_validate := apex_util.string_to_table(
                                 p_string    => l_items_to_validate,
                                 p_separator => lco_page_item_separator
                               );

    l_items_to_validate := '';
    for i in 1 .. l_tmp_items_to_validate.count loop
      l_items_to_validate := l_items_to_validate || lco_jquery_id_selector || l_tmp_items_to_validate(i) || lco_page_item_separator;
    end loop;
  end if;

  l_render_result.attribute_01 := l_validation;
  l_render_result.attribute_02 := l_items_to_validate;
  l_render_result.attribute_03 := l_triggering_event;
  l_render_result.attribute_04 := l_condition;
  l_render_result.attribute_05 := l_form_to_validate;
  l_render_result.attribute_06 := l_item_type;
  l_render_result.attribute_07 := l_form_submit_elements;
  if l_minimum_item is not null then
    l_minimum_item := lco_jquery_id_selector || l_minimum_item;
  end if;
  if l_maximum_item is not null then
    l_maximum_item := lco_jquery_id_selector || l_maximum_item;
  end if;
  l_render_result.attribute_10 := nvl(l_minimum_item, l_minimum);
  l_render_result.attribute_11 := nvl(l_maximum_item, l_maximum);
  l_render_result.attribute_12 := l_equal;
  l_render_result.attribute_13 := l_regex;
  l_render_result.attribute_14 := l_error_msg;
  l_render_result.attribute_15 := l_error_msg_location;

  l_render_result.javascript_function := '
    function() {
      var render = this;
      var action = render.action;
      var l_allowWhitespace = true;

      // error message
      if (!action.attribute14) { action.attribute14 = ""; }

      if (action.attribute01 !== "form") {
        // ITEM VALIDATION

        // allow whitespace
        if (action.attribute01 === "notBlank") {
          action.attribute01 = "notEmpty";
          l_allowWhitespace = false;
        }
        // condition
        if (!action.attribute04) { action.attribute04 = ""; }
        // min and max
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
          min: action.attribute10,
          max: action.attribute11,
          equal: action.attribute12,
          regex: action.attribute13
        });
      } else {
        // FORM VALIDATION

        $(action.attribute05).alv("validateForm", {
          formSubmitElems: action.attribute07,
          errorMsg: action.attribute14
        });
      }
    }
  ';

  return l_render_result;
end render;