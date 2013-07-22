set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,55691954624826792581));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,59381);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/be_ctb_jq_alv
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'BE.CTB.JQ.ALV'
 ,p_display_name => 'Live Validation'
 ,p_category => 'COMPONENT'
 ,p_supported_ui_types => 'DESKTOP:JQM_SMARTPHONE'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render(p_dynamic_action in apex_plugin.t_dynamic_action'||unistr('\000a')||
'              , p_plugin         in apex_plugin.t_plugin)'||unistr('\000a')||
'return apex_plugin.t_dynamic_action_render_result is'||unistr('\000a')||
'  lco_jquery_id_selector  constant char := ''#'';'||unistr('\000a')||
'  lco_page_item_separator constant char := '','';'||unistr('\000a')||
''||unistr('\000a')||
'  l_validation           varchar2(4000) := p_dynamic_action.attribute_01;'||unistr('\000a')||
'  l_items_to_validate    varchar2(4000) := p_dynamic_'||
'action.attribute_02;'||unistr('\000a')||
'  l_triggering_event     varchar2(4000) := p_dynamic_action.attribute_03;'||unistr('\000a')||
'  l_condition            varchar2(4000) := p_dynamic_action.attribute_04;'||unistr('\000a')||
'  l_form_to_validate     varchar2(4000) := p_dynamic_action.attribute_05;'||unistr('\000a')||
'  l_item_type            varchar2(4000) := p_dynamic_action.attribute_06;'||unistr('\000a')||
'  l_form_submit_elements varchar2(4000) := p_dynamic_action.attribute_07;'||unistr('\000a')||
'  l_minim'||
'um_item         varchar2(4000) := p_dynamic_action.attribute_08;'||unistr('\000a')||
'  l_maximum_item         varchar2(4000) := p_dynamic_action.attribute_09;'||unistr('\000a')||
'  l_minimum              varchar2(4000) := p_dynamic_action.attribute_10;'||unistr('\000a')||
'  l_maximum              varchar2(4000) := p_dynamic_action.attribute_11;'||unistr('\000a')||
'  l_equal                varchar2(4000) := p_dynamic_action.attribute_12;'||unistr('\000a')||
'  l_regex                varchar2(4000)'||
' := p_dynamic_action.attribute_13;'||unistr('\000a')||
'  l_error_msg            varchar2(4000) := p_dynamic_action.attribute_14;'||unistr('\000a')||
'  l_error_msg_location   varchar2(4000) := p_dynamic_action.attribute_15;'||unistr('\000a')||
''||unistr('\000a')||
'  l_date_format varchar2(4000);'||unistr('\000a')||
'  l_tmp_items_to_validate apex_application_global.vc_arr2;'||unistr('\000a')||
''||unistr('\000a')||
'  l_render_result apex_plugin.t_dynamic_action_render_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  apex_javascript.add_library('||unistr('\000a')||
'    p_name      => ''jquer'||
'y.alv'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
'  apex_css.add_file('||unistr('\000a')||
'    p_name      => ''style.alv'','||unistr('\000a')||
'    p_directory => p_plugin.file_prefix,'||unistr('\000a')||
'    p_version   => null'||unistr('\000a')||
'  );'||unistr('\000a')||
''||unistr('\000a')||
'  select value'||unistr('\000a')||
'  into l_date_format'||unistr('\000a')||
'  from nls_session_parameters'||unistr('\000a')||
'  where parameter = ''NLS_DATE_FORMAT'';'||unistr('\000a')||
''||unistr('\000a')||
'  if l_validation != ''form'' then'||unistr('\000a')||
'    l_tmp_items_to_validate := apex_util.string_to_table('||unistr('\000a')||
' '||
'                                p_string    => l_items_to_validate,'||unistr('\000a')||
'                                 p_separator => lco_page_item_separator'||unistr('\000a')||
'                               );'||unistr('\000a')||
''||unistr('\000a')||
'    l_items_to_validate := '''';'||unistr('\000a')||
'    for i in 1 .. l_tmp_items_to_validate.count loop'||unistr('\000a')||
'      l_items_to_validate := l_items_to_validate || lco_jquery_id_selector || l_tmp_items_to_validate(i) || lco_page_item_separator;'||unistr('\000a')||
'    end '||
'loop;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  l_render_result.attribute_01 := l_validation;'||unistr('\000a')||
'  l_render_result.attribute_02 := l_items_to_validate;'||unistr('\000a')||
'  l_render_result.attribute_03 := l_triggering_event;'||unistr('\000a')||
'  l_render_result.attribute_04 := l_condition;'||unistr('\000a')||
'  l_render_result.attribute_05 := l_form_to_validate;'||unistr('\000a')||
'  l_render_result.attribute_06 := l_item_type;'||unistr('\000a')||
'  l_render_result.attribute_07 := l_form_submit_elements;'||unistr('\000a')||
'  if l_minimum_item '||
'is not null then'||unistr('\000a')||
'    l_minimum_item := lco_jquery_id_selector || l_minimum_item;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  if l_maximum_item is not null then'||unistr('\000a')||
'    l_maximum_item := lco_jquery_id_selector || l_maximum_item;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
'  l_render_result.attribute_10 := nvl(l_minimum_item, l_minimum);'||unistr('\000a')||
'  l_render_result.attribute_11 := nvl(l_maximum_item, l_maximum);'||unistr('\000a')||
'  l_render_result.attribute_12 := lco_jquery_id_selector || l_equa'||
'l;'||unistr('\000a')||
'  l_render_result.attribute_13 := l_regex;'||unistr('\000a')||
'  l_render_result.attribute_14 := l_error_msg;'||unistr('\000a')||
'  l_render_result.attribute_15 := l_error_msg_location;'||unistr('\000a')||
''||unistr('\000a')||
'  l_render_result.javascript_function := '''||unistr('\000a')||
'    function() {'||unistr('\000a')||
'      var render = this;'||unistr('\000a')||
'      var action = render.action;'||unistr('\000a')||
'      var l_allowWhitespace = true;'||unistr('\000a')||
''||unistr('\000a')||
'      // error message'||unistr('\000a')||
'      if (!action.attribute14) { action.attribute14 = ""; }'||unistr('\000a')||
''||unistr('\000a')||
'      if ('||
'action.attribute01 !== "form") {'||unistr('\000a')||
'        // ITEM VALIDATION'||unistr('\000a')||
''||unistr('\000a')||
'        // allow whitespace'||unistr('\000a')||
'        if (action.attribute01 === "notBlank") {'||unistr('\000a')||
'          action.attribute01 = "notEmpty";'||unistr('\000a')||
'          l_allowWhitespace = false;'||unistr('\000a')||
'        }'||unistr('\000a')||
'        // condition'||unistr('\000a')||
'        if (!action.attribute04) { action.attribute04 = ""; }'||unistr('\000a')||
'        // min and max'||unistr('\000a')||
'        if (!action.attribute10) { action.attribute10 = ""; }'||unistr('\000a')||
'    '||
'    if (!action.attribute11) { action.attribute11 = ""; }'||unistr('\000a')||
''||unistr('\000a')||
'        $(action.attribute02).alv({'||unistr('\000a')||
'          validate: action.attribute01,'||unistr('\000a')||
'          triggeringEvent: action.attribute03,'||unistr('\000a')||
'          condition: action.attribute04,'||unistr('\000a')||
'          errorMsg: action.attribute14,'||unistr('\000a')||
'          errorMsgLocation: action.attribute15,'||unistr('\000a')||
'          allowWhitespace: l_allowWhitespace,'||unistr('\000a')||
'          itemType: action.attribute06,'||unistr('\000a')||
'   '||
'       dateFormat: "'' || l_date_format || ''",'||unistr('\000a')||
'          min: action.attribute10,'||unistr('\000a')||
'          max: action.attribute11,'||unistr('\000a')||
'          equal: action.attribute12,'||unistr('\000a')||
'          regex: action.attribute13'||unistr('\000a')||
'        });'||unistr('\000a')||
'      } else {'||unistr('\000a')||
'        // FORM VALIDATION'||unistr('\000a')||
''||unistr('\000a')||
'        $(action.attribute07).alv("validateForm", {'||unistr('\000a')||
'          formsToSubmit: action.attribute05,'||unistr('\000a')||
'          errorMsg: action.attribute14'||unistr('\000a')||
'        });'||unistr('\000a')||
'      }'||unistr('\000a')||
''||
'    }'||unistr('\000a')||
'  '';'||unistr('\000a')||
''||unistr('\000a')||
'  return l_render_result;'||unistr('\000a')||
'end render;'
 ,p_render_function => 'render'
 ,p_standard_attributes => 'STOP_EXECUTION_ON_ERROR'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '1.0'
 ,p_about_url => 'http://apex.oracle.com/pls/apex/f?p=59381:1'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Validation'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'notEmpty'
 ,p_is_translatable => false
 ,p_help_text => 'Select the type of validation you want to perform.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360126995846071147 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Required'
 ,p_return_value => 'notEmpty'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69342188560568533573 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 15
 ,p_display_value => 'Required (Trim Whitespace)'
 ,p_return_value => 'notBlank'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360127412845108808 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Item Type'
 ,p_return_value => 'itemType'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360130414084852888 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Equality'
 ,p_return_value => 'equal'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360130811927853929 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Match Regex'
 ,p_return_value => 'regex'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360131209555855082 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Character Length'
 ,p_return_value => 'charLength'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360131604595857368 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 60
 ,p_display_value => 'Number Size'
 ,p_return_value => 'numberSize'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360132000066859431 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 70
 ,p_display_value => 'Date Order'
 ,p_return_value => 'dateOrder'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360132396615861046 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 80
 ,p_display_value => 'Checkboxes'
 ,p_return_value => 'totalChecked'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69342170366168887618 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 90
 ,p_display_value => 'Form'
 ,p_return_value => 'form'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360111813184186440 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 30
 ,p_prompt => 'Page Item(s)'
 ,p_attribute_type => 'PAGE ITEMS'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'The page item(s) for which you want the above validation to apply. Separate multiple page items with a comma.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360112199382192811 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 40
 ,p_prompt => 'Triggering Event'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'blur'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'Specify the JavaScript event that will cause the validation to fire.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360112609721203289 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360112199382192811 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Blur'
 ,p_return_value => 'blur'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360232699362067469 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360112199382192811 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'FocusOut'
 ,p_return_value => 'focusout'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360112997644208888 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360112199382192811 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Change'
 ,p_return_value => 'change'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360113388155213293 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360112199382192811 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'KeyUp'
 ,p_return_value => 'keyup'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69475962571818410850 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 50
 ,p_prompt => 'Condition'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'Optionally specify a JavaScript expression to support conditional execution of your validation. The validation will fire when the expression evaluates to true.'||unistr('\000a')||
''||unistr('\000a')||
'For example: $(''#P5_COUNTRY'').val() === "Belgium"'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69342180875042496547 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 120
 ,p_prompt => 'Form'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'A jQuery selector to determine the form region(s) you want to validate before the page is submitted. Use a comma to separate multiple elements.'||unistr('\000a')||
''||unistr('\000a')||
'For example: #empForm,#deptForm'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 20
 ,p_prompt => 'Item Type'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'number'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'itemType'
 ,p_help_text => 'Define what kind of item type validation should be applied.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360135191765258259 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Number'
 ,p_return_value => 'number'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360135588530259764 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Only Digits'
 ,p_return_value => 'digit'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360136018710260995 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Alphanumeric'
 ,p_return_value => 'alphanumeric'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360136416769261878 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Date'
 ,p_return_value => 'date'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360136815044262640 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'E-mail'
 ,p_return_value => 'email'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360137213966263192 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360134793922257266 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 60
 ,p_display_value => 'URL'
 ,p_return_value => 'url'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69342181888185505616 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 130
 ,p_prompt => 'Form Submit Element(s)'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'A jQuery selector to determine the buttons that submit the form. Use a comma to separate multiple elements.'||unistr('\000a')||
''||unistr('\000a')||
'For example: #createBtn,#saveBtn'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360141700464694797 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 60
 ,p_prompt => 'Minimum Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'numberSize,dateOrder'
 ,p_help_text => 'The page item that contains the minimum value. Overrides the ''Minimum'' setting if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360142095504697064 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 70
 ,p_prompt => 'Maximum Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'numberSize,dateOrder'
 ,p_help_text => 'The page item that contains the maximum value. Overrides the ''Maximum'' setting if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360138016812474537 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 80
 ,p_prompt => 'Minimum'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 30
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'charLength,numberSize,dateOrder,totalChecked'
 ,p_help_text => 'A fixed minimum value. Gets overridden by the ''Minimum Item'' setting if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360138412930476312 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 90
 ,p_prompt => 'Maximum'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 30
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'charLength,numberSize,dateOrder,totalChecked'
 ,p_help_text => 'A fixed maximum value. Gets overridden by the ''Maximum Item'' setting if filled in.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360142600403770828 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 12
 ,p_display_sequence => 100
 ,p_prompt => 'Must Equal'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'equal'
 ,p_help_text => 'Select the page item that you want the value to be equal to. Frequently used to validate that two password fields are equal.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360142991129775050 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 13
 ,p_display_sequence => 110
 ,p_prompt => 'Regex'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => 'regex'
 ,p_help_text => 'This field allows specifying a regular expression that has to match the entered value.'||unistr('\000a')||
''||unistr('\000a')||
'For example: #[A-Fa-f0-9]{6}'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360143713268855988 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 14
 ,p_display_sequence => 140
 ,p_prompt => 'Error Message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'Specifying an error message overrides the default error message. Use &1, &2, &n for substitution values.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 69360144106367859186 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 15
 ,p_display_sequence => 150
 ,p_prompt => 'Error Message Location'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'after'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 69360126606414066172 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_IN_LIST'
 ,p_depending_on_expression => 'form'
 ,p_help_text => 'You can choose to show the error message before or after the input item.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360144895584864194 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360144106367859186 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'After Item'
 ,p_return_value => 'after'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 69360144498388862840 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 69360144106367859186 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Before Item'
 ,p_return_value => 'before'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20696E6C696E65202A2F0A696E7075742E616C762D6974656D2D6572726F722C0A74657874617265612E616C762D6974656D2D6572726F722C0A73656C6563742E616C762D6974656D2D6572726F72207B0A20202020626F726465723A2031707820';
wwv_flow_api.g_varchar2_table(2) := '736F6C696420236239346134383B0A202020206261636B67726F756E642D636F6C6F723A20236635656165613B0A7D0A0A2E616C762D6C6162656C2D6572726F72207B0A20202020636F6C6F723A20236239346134383B0A7D0A0A2E616C762D6572726F';
wwv_flow_api.g_varchar2_table(3) := '722D6D7367207B0A20202020646973706C61793A20626C6F636B3B0A20202020636F6C6F723A20236239346134383B0A20202020666F6E742D73697A653A20313370783B0A202020206C696E652D6865696768743A20323070783B0A7D0A0A2F2A206E6F';
wwv_flow_api.g_varchar2_table(4) := '74696669636174696F6E202A2F0A23616C762D6D73672D626F78207B0A20202020706F736974696F6E3A2066697865643B0A20202020746F703A20303B0A202020206C6566743A203530253B0A2020202077696474683A2036303070783B0A202020206D';
wwv_flow_api.g_varchar2_table(5) := '617267696E2D6C6566743A202D33303070783B0A202020206D696E2D6865696768743A20303B0A20202020626F726465723A20303B0A202020207A2D696E6465783A20393939393B0A7D0A0A2E616C762D616C6572742D6D7367207B0A20202020626163';
wwv_flow_api.g_varchar2_table(6) := '6B67726F756E642D636F6C6F723A20236632646564653B0A20202020636F6C6F723A20236239346134383B0A20202020746578742D736861646F773A20302031707820302072676261283235352C203235352C203235352C20302E35293B0A2020202062';
wwv_flow_api.g_varchar2_table(7) := '6F726465723A2031707820736F6C696420236565643364373B0A2020202070616464696E673A20313470782033357078203134707820313470783B0A202020202D7765626B69742D626F726465722D7261646975733A2030203020347078203470783B0A';
wwv_flow_api.g_varchar2_table(8) := '202020202D6D6F7A2D626F726465722D7261646975733A2030203020347078203470783B0A20202020626F726465722D7261646975733A2030203020347078203470783B0A20202020626F782D736861646F773A20302032707820357078207267626128';
wwv_flow_api.g_varchar2_table(9) := '302C20302C20302C20302E31293B0A7D0A0A2E616C762D636C6F7365207B0A20202020666C6F61743A2072696768743B0A20202020706F736974696F6E3A2072656C61746976653B0A20202020746F703A202D3270783B0A2020202072696768743A202D';
wwv_flow_api.g_varchar2_table(10) := '323170783B0A20202020666F6E742D73697A653A20313670783B0A20202020666F6E742D7765696768743A20626F6C643B0A202020206C696E652D6865696768743A20323070783B0A20202020636F6C6F723A20233030303030303B0A20202020746578';
wwv_flow_api.g_varchar2_table(11) := '742D6465636F726174696F6E3A206E6F6E653B0A20202020746578742D736861646F773A203020317078203020236666666666663B0A202020206F7061636974793A202E323B0A2020202066696C7465723A20616C706861286F7061636974793D323029';
wwv_flow_api.g_varchar2_table(12) := '3B0A7D0A0A2E616C762D636C6F73653A686F766572207B0A20202020636F6C6F723A20233030303030303B0A20202020746578742D6465636F726174696F6E3A206E6F6E653B0A202020206F7061636974793A202E353B0A2020202066696C7465723A20';
wwv_flow_api.g_varchar2_table(13) := '616C706861286F7061636974793D3530293B0A7D0A0A2E616C762D616C6572742D6D73672070207B0A20202020666F6E742D73697A653A20313670783B0A20202020666F6E742D7765696768743A20626F6C643B0A202020206C696E652D686569676874';
wwv_flow_api.g_varchar2_table(14) := '3A20323070783B0A202020206D617267696E3A20303B0A7D0A0A406D6564696120286D61782D77696474683A20393739707829207B0A2020202023616C762D6D73672D626F78207B0A202020202020202077696474683A2034303070783B0A2020202020';
wwv_flow_api.g_varchar2_table(15) := '2020206D617267696E2D6C6566743A202D32303070783B0A202020207D0A7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 23372441210466506887 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_file_name => 'style.alv.css'
 ,p_mime_type => 'text/css'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2275736520737472696374223B76617220616C763D7B7D3B616C762E7574696C3D7B7472696D3A66756E6374696F6E2874297B72657475726E20742E7265706C616365282F5E5C732B7C5C732B242F672C2222297D2C676574506167654974656D56616C';
wwv_flow_api.g_varchar2_table(2) := '75653A66756E6374696F6E2874297B72657475726E20742E737562737472696E6728302C32293D3D3D222350223F242874292E76616C28293A747D2C676574436F6E646974696F6E526573756C743A66756E6374696F6E287045787072657373696F6E29';
wwv_flow_api.g_varchar2_table(3) := '7B7661722065787072657373696F6E526573756C743D21303B72657475726E207045787072657373696F6E2E6C656E67746826262865787072657373696F6E526573756C743D6576616C287045787072657373696F6E29292C65787072657373696F6E52';
wwv_flow_api.g_varchar2_table(4) := '6573756C747D2C6765744E756D62657246726F6D537472696E673A66756E6374696F6E2874297B72657475726E20742E6C656E6774683F4E756D6265722874293A22227D2C6765744461746546726F6D537472696E673A66756E6374696F6E2874297B76';
wwv_flow_api.g_varchar2_table(5) := '617220733D742E73706C697428222F22292C653D7061727365496E7428735B325D292C693D7061727365496E7428735B315D2C3130292C613D7061727365496E7428735B305D2C3130293B72657475726E206E6577204461746528652C692D312C61297D';
wwv_flow_api.g_varchar2_table(6) := '2C636F6E76657274446174653A66756E6374696F6E28742C73297B76617220652C692C612C6E3D732E746F55707065724361736528292C723D6E2E7265706C616365282F5B412D5A5D2B2F672C2222292C6F3D742E7265706C616365282F5C642B2F672C';
wwv_flow_api.g_varchar2_table(7) := '2222293B72657475726E20742E6C656E6774683D3D3D732E6C656E67746826266F3D3D3D72262628653D6E2E696E6465784F662822444422293D3D3D2D313F227878223A742E737562737472696E67286E2E696E6465784F662822444422292C6E2E696E';
wwv_flow_api.g_varchar2_table(8) := '6465784F662822444422292B32292C693D6E2E696E6465784F6628224D4D22293D3D3D2D313F227878223A742E737562737472696E67286E2E696E6465784F6628224D4D22292C6E2E696E6465784F6628224D4D22292B32292C613D6E2E696E6465784F';
wwv_flow_api.g_varchar2_table(9) := '6628225959595922293D3D3D2D313F6E2E696E6465784F6628225252525222293D3D3D2D313F6E2E696E6465784F662822595922293D3D3D2D313F6E2E696E6465784F662822525222293D3D3D2D313F2278787878223A742E737562737472696E67286E';
wwv_flow_api.g_varchar2_table(10) := '2E696E6465784F662822525222292C6E2E696E6465784F662822525222292B32293A742E737562737472696E67286E2E696E6465784F662822595922292C6E2E696E6465784F662822595922292B32293A742E737562737472696E67286E2E696E646578';
wwv_flow_api.g_varchar2_table(11) := '4F6628225252525222292C6E2E696E6465784F6628225252525222292B34293A742E737562737472696E67286E2E696E6465784F6628225959595922292C6E2E696E6465784F6628225959595922292B3429292C652B222F222B692B222F222B617D7D2C';
wwv_flow_api.g_varchar2_table(12) := '616C762E76616C696461746F72733D7B7574696C3A616C762E7574696C2C6973456D7074793A66756E6374696F6E2874297B72657475726E20743D3D3D22227D2C6973457175616C3A66756E6374696F6E28742C73297B72657475726E20743D3D3D737D';
wwv_flow_api.g_varchar2_table(13) := '2C72656765783A66756E6374696F6E28742C73297B72657475726E205265674578702873292E746573742874297C7C746869732E6973456D7074792874297D2C6973416C7068616E756D657269633A66756E6374696F6E2874297B72657475726E207468';
wwv_flow_api.g_varchar2_table(14) := '69732E726567657828742C2F5E5B612D7A302D395D2B242F69297D2C69734E756D6265723A66756E6374696F6E2874297B72657475726E20746869732E726567657828742C2F5E2D3F283F3A5C642B7C5C647B312C337D283F3A2C5C647B337D292B293F';
wwv_flow_api.g_varchar2_table(15) := '283F3A5C2E5C642B293F242F297D2C697344696769743A66756E6374696F6E2874297B72657475726E20746869732E726567657828742C2F5E5C642B242F297D2C6973456D61696C3A66756E6374696F6E2874297B72657475726E20746869732E726567';
wwv_flow_api.g_varchar2_table(16) := '657828742C2F5E5B5E5C73405D2B405B5E5C73405D2B5C2E5B5E5C73405D2B242F297D2C697355726C3A66756E6374696F6E2874297B72657475726E20746869732E726567657828742C2F28687474707C6674707C6874747073293A5C2F5C2F5B5C772D';
wwv_flow_api.g_varchar2_table(17) := '5D2B285C2E5B5C772D5D2B292B285B5C772E2C403F5E3D2526616D703B3A5C2F7E2B232D5D2A5B5C77403F5E3D2526616D703B5C2F7E2B232D5D293F2F297D2C6973446174653A66756E6374696F6E28742C73297B76617220653D52656745787028225E';
wwv_flow_api.g_varchar2_table(18) := '28335B30315D7C5B31325D5B302D395D7C303F5B312D395D292F28315B302D325D7C303F5B312D395D292F283F3A5B302D395D7B327D293F5B302D395D7B327D2422292C693D746869732E7574696C2E636F6E766572744461746528742C73293B696628';
wwv_flow_api.g_varchar2_table(19) := '692E6D61746368286529297B76617220613D692E73706C697428222F22292C6E3D7061727365496E7428615B325D292C723D7061727365496E7428615B315D2C3130292C6F3D7061727365496E7428615B305D2C3130292C6C3D6E65772044617465286E';
wwv_flow_api.g_varchar2_table(20) := '2C722D312C6F293B6966286C2E6765744D6F6E746828292B313D3D3D7226266C2E6765744461746528293D3D3D6F26266C2E67657446756C6C5965617228293D3D3D6E2972657475726E21307D72657475726E20746869732E6973456D7074792874297D';
wwv_flow_api.g_varchar2_table(21) := '2C6D696E4C656E6774683A66756E6374696F6E28742C73297B72657475726E20742E6C656E6774683E3D737C7C746869732E6973456D7074792874297D2C6D61784C656E6774683A66756E6374696F6E28742C73297B72657475726E20733E3D742E6C65';
wwv_flow_api.g_varchar2_table(22) := '6E6774687C7C746869732E6973456D7074792874297D2C72616E67654C656E6774683A66756E6374696F6E28742C732C65297B72657475726E20746869732E6D696E4C656E67746828742C73292626746869732E6D61784C656E67746828742C65297C7C';
wwv_flow_api.g_varchar2_table(23) := '746869732E6973456D7074792874297D2C6D696E4E756D6265723A66756E6374696F6E28742C73297B72657475726E21746869732E6973456D707479287429262621746869732E6973456D7074792873292626746869732E69734E756D62657228742926';
wwv_flow_api.g_varchar2_table(24) := '26746869732E69734E756D6265722873293F743E3D733A21307D2C6D61784E756D6265723A66756E6374696F6E28742C73297B72657475726E21746869732E6973456D707479287429262621746869732E6973456D7074792873292626746869732E6973';
wwv_flow_api.g_varchar2_table(25) := '4E756D6265722874292626746869732E69734E756D6265722873293F733E3D743A21307D2C72616E67654E756D6265723A66756E6374696F6E28742C732C65297B72657475726E20746869732E6973456D7074792874297C7C746869732E6973456D7074';
wwv_flow_api.g_varchar2_table(26) := '792873297C7C746869732E6973456D7074792865297C7C2128746869732E69734E756D6265722874292626746869732E69734E756D6265722873292626746869732E69734E756D626572286529297C7C733E653F21303A746869732E6D696E4E756D6265';
wwv_flow_api.g_varchar2_table(27) := '7228742C73292626746869732E6D61784E756D62657228742C65297D2C6D696E436865636B3A66756E6374696F6E28742C732C65297B76617220693D242874292E66696C74657228223A636865636B656422292E6C656E6774683B72657475726E20653F';
wwv_flow_api.g_varchar2_table(28) := '746869732E6D696E4E756D62657228692C73297C7C693D3D3D303A746869732E6D696E4E756D62657228692C73297D2C6D6178436865636B3A66756E6374696F6E28742C73297B76617220653D242874292E66696C74657228223A636865636B65642229';
wwv_flow_api.g_varchar2_table(29) := '2E6C656E6774683B72657475726E20746869732E6D61784E756D62657228652C73297C7C653D3D3D307D2C72616E6765436865636B3A66756E6374696F6E28742C732C65297B76617220693D242874292E66696C74657228223A636865636B656422292E';
wwv_flow_api.g_varchar2_table(30) := '6C656E6774683B72657475726E20746869732E72616E67654E756D62657228692C732C65297C7C693D3D3D307D2C6D696E446174653A66756E6374696F6E28742C732C65297B76617220693D6E657720446174652C613D6E657720446174653B72657475';
wwv_flow_api.g_varchar2_table(31) := '726E21746869732E6973456D707479287429262621746869732E6973456D7074792873292626746869732E69734461746528742C65292626746869732E69734461746528732C65293F28693D746869732E7574696C2E6765744461746546726F6D537472';
wwv_flow_api.g_varchar2_table(32) := '696E6728746869732E7574696C2E636F6E766572744461746528742C6529292C613D746869732E7574696C2E6765744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461746528732C6529292C693E3D61293A21307D2C';
wwv_flow_api.g_varchar2_table(33) := '6D6178446174653A66756E6374696F6E28742C732C65297B76617220693D6E657720446174652C613D6E657720446174653B72657475726E21746869732E6973456D707479287429262621746869732E6973456D7074792873292626746869732E697344';
wwv_flow_api.g_varchar2_table(34) := '61746528742C65292626746869732E69734461746528732C65293F28693D746869732E7574696C2E6765744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461746528742C6529292C613D746869732E7574696C2E6765';
wwv_flow_api.g_varchar2_table(35) := '744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461746528732C6529292C613E3D69293A21307D2C72616E6765446174653A66756E6374696F6E28742C732C652C69297B76617220613D6E657720446174652C6E3D6E';
wwv_flow_api.g_varchar2_table(36) := '657720446174652C723D6E657720446174653B72657475726E20746869732E6973456D7074792874297C7C746869732E6973456D7074792873297C7C746869732E6973456D7074792865297C7C2128746869732E69734461746528742C69292626746869';
wwv_flow_api.g_varchar2_table(37) := '732E69734461746528732C69292626746869732E69734461746528652C6929297C7C28613D746869732E7574696C2E6765744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461746528742C6929292C6E3D746869732E';
wwv_flow_api.g_varchar2_table(38) := '7574696C2E6765744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461746528732C6929292C723D746869732E7574696C2E6765744461746546726F6D537472696E6728746869732E7574696C2E636F6E766572744461';
wwv_flow_api.g_varchar2_table(39) := '746528652C6929292C6E3E72293F21303A613E3D6E2626723E3D617D7D2C66756E6374696F6E28242C7574696C2C76616C696461746F7273297B242E666E2E616C763D66756E6374696F6E286D6574686F642C6F7074696F6E73297B66756E6374696F6E';
wwv_flow_api.g_varchar2_table(40) := '20726573746F7265506C7567696E53657474696E67732874297B76617220733D242874293B72657475726E20732E6461746128636F6E7374616E74732E706C7567696E496429213D3D766F696420303F28242E657874656E642873657474696E67732C73';
wwv_flow_api.g_varchar2_table(41) := '2E6461746128636F6E7374616E74732E706C7567696E496429292C2130293A21317D66756E6374696F6E20657874656E6453657474696E67732874297B742626242E657874656E642873657474696E67732C74297D66756E6374696F6E2062696E645365';
wwv_flow_api.g_varchar2_table(42) := '7474696E677328742C73297B657874656E6453657474696E67732873292C242874292E6461746128636F6E7374616E74732E706C7567696E49642C73657474696E6773297D66756E6374696F6E20696E69742874297B76617220733D73657474696E6773';
wwv_flow_api.g_varchar2_table(43) := '2E74726967676572696E674576656E742B222E222B636F6E7374616E74732E706C7567696E5072656669782C653D226368616E67652E222B636F6E7374616E74732E706C7567696E5072656669783B7377697463682873657474696E67732E76616C6964';
wwv_flow_api.g_varchar2_table(44) := '617465297B63617365226E6F74456D707479223A28242874292E686173436C61737328636F6E7374616E74732E61706578436865636B626F78436C617373297C7C242874292E686173436C61737328636F6E7374616E74732E61706578526164696F436C';
wwv_flow_api.g_varchar2_table(45) := '617373297C7C242874292E686173436C61737328636F6E7374616E74732E6170657853687574746C65436C617373297C7C242874292E70726F7028227461674E616D6522293D3D3D2253454C454354227C7C242874292E6174747228227479706522293D';
wwv_flow_api.g_varchar2_table(46) := '3D3D2266696C652229262673657474696E67732E74726967676572696E674576656E74213D3D226368616E676522262628733D732B2220222B65292C742E6F6E28732C6973456D70747948616E646C6572293B627265616B3B63617365226974656D5479';
wwv_flow_api.g_varchar2_table(47) := '7065223A742E6F6E28732C6974656D5479706548616E646C6572293B627265616B3B6361736522657175616C223A742E6F6E28732C6973457175616C48616E646C6572293B627265616B3B63617365227265676578223A742E6F6E28732C726567657848';
wwv_flow_api.g_varchar2_table(48) := '616E646C6572293B627265616B3B6361736522636861724C656E677468223A742E6F6E28732C636861724C656E67746848616E646C6572293B627265616B3B63617365226E756D62657253697A65223A742E6F6E28732C6E756D62657253697A6548616E';
wwv_flow_api.g_varchar2_table(49) := '646C6572293B627265616B3B6361736522646174654F72646572223A742E6F6E28732C646174654F7264657248616E646C6572293B627265616B3B6361736522746F74616C436865636B6564223A742E6F6E28652C746F74616C436865636B656448616E';
wwv_flow_api.g_varchar2_table(50) := '646C6572293B627265616B3B64656661756C743A7D72657475726E20747D66756E6374696F6E206973456D70747948616E646C657228297B76617220742C733D7365744D73672873657474696E67732E6572726F724D73672C2276616C75652072657175';
wwv_flow_api.g_varchar2_table(51) := '6972656422293B616C6C6F7756616C69646174696F6E28746869732C636F6E7374616E74732E6E6F74456D707479436C61737329262628743D242874686973292E686173436C61737328636F6E7374616E74732E61706578436865636B626F78436C6173';
wwv_flow_api.g_varchar2_table(52) := '73297C7C242874686973292E686173436C61737328636F6E7374616E74732E61706578526164696F436C617373293F2176616C696461746F72732E6D696E436865636B28242874686973292E66696E6428223A636865636B626F782C203A726164696F22';
wwv_flow_api.g_varchar2_table(53) := '292C312C2131293A242874686973292E686173436C61737328636F6E7374616E74732E6170657853687574746C65436C617373293F21242874686973292E66696E64282273656C6563742E73687574746C655F726967687422292E6368696C6472656E28';
wwv_flow_api.g_varchar2_table(54) := '292E6C656E6774683A242874686973292E70726F7028227461674E616D6522293D3D3D2253454C454354227C7C242874686973292E6174747228227479706522293D3D3D2266696C65223F76616C696461746F72732E6973456D70747928746869732E76';
wwv_flow_api.g_varchar2_table(55) := '616C7565293A73657474696E67732E616C6C6F77576869746573706163653F76616C696461746F72732E6973456D70747928746869732E76616C7565293A76616C696461746F72732E6973456D707479287574696C2E7472696D28746869732E76616C75';
wwv_flow_api.g_varchar2_table(56) := '6529292C7426267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E6E6F74456D707479436C617373';
wwv_flow_api.g_varchar2_table(57) := '2C2131292C73686F774D65737361676528746869732C7329293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E6E6F74456D707479436C6173732C2130292C686964654D65737361676528746869732929297D';
wwv_flow_api.g_varchar2_table(58) := '66756E6374696F6E206973457175616C48616E646C657228297B76617220743D7365744D73672873657474696E67732E6572726F724D73672C2276616C75657320646F206E6F7420657175616C22293B616C6C6F7756616C69646174696F6E2874686973';
wwv_flow_api.g_varchar2_table(59) := '2C636F6E7374616E74732E657175616C436C61737329262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C69646174696F6E4D696E4C656E677468292626282176616C696461746F72732E';
wwv_flow_api.g_varchar2_table(60) := '6973457175616C28746869732E76616C75652C242873657474696E67732E657175616C292E76616C28292926267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174';
wwv_flow_api.g_varchar2_table(61) := '696F6E526573756C7428746869732C636F6E7374616E74732E657175616C436C6173732C2131292C73686F774D65737361676528746869732C7429293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E657175';
wwv_flow_api.g_varchar2_table(62) := '616C436C6173732C2130292C686964654D65737361676528746869732929297D66756E6374696F6E20726567657848616E646C657228297B76617220743D7365744D73672873657474696E67732E6572726F724D73672C22696E76616C69642076616C75';
wwv_flow_api.g_varchar2_table(63) := '6522293B616C6C6F7756616C69646174696F6E28746869732C636F6E7374616E74732E7265676578436C61737329262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C69646174696F6E4D';
wwv_flow_api.g_varchar2_table(64) := '696E4C656E677468292626282176616C696461746F72732E726567657828746869732E76616C75652C73657474696E67732E72656765782926267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E';
wwv_flow_api.g_varchar2_table(65) := '293F2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E7265676578436C6173732C2131292C73686F774D65737361676528746869732C7429293A2873657456616C69646174696F6E526573756C7428746869732C';
wwv_flow_api.g_varchar2_table(66) := '636F6E7374616E74732E7265676578436C6173732C2130292C686964654D65737361676528746869732929297D66756E6374696F6E206974656D5479706548616E646C657228297B76617220742C733B696628616C6C6F7756616C69646174696F6E2874';
wwv_flow_api.g_varchar2_table(67) := '6869732C636F6E7374616E74732E6974656D54797065436C61737329262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C69646174696F6E4D696E4C656E67746829297B73776974636828';
wwv_flow_api.g_varchar2_table(68) := '73657474696E67732E6974656D54797065297B6361736522616C7068616E756D65726963223A743D76616C696461746F72732E6973416C7068616E756D6572696328746869732E76616C7565292C733D7365744D73672873657474696E67732E6572726F';
wwv_flow_api.g_varchar2_table(69) := '724D73672C226E6F7420616E20616C7068616E756D657269632076616C756522293B627265616B3B63617365226E756D626572223A743D76616C696461746F72732E69734E756D62657228746869732E76616C7565292C733D7365744D73672873657474';
wwv_flow_api.g_varchar2_table(70) := '696E67732E6572726F724D73672C226E6F7420612076616C6964206E756D62657222293B627265616B3B63617365226469676974223A743D76616C696461746F72732E6973446967697428746869732E76616C7565292C733D7365744D73672873657474';
wwv_flow_api.g_varchar2_table(71) := '696E67732E6572726F724D73672C226E6F7420612076616C696420646967697420636F6D62696E6174696F6E22293B627265616B3B6361736522656D61696C223A743D76616C696461746F72732E6973456D61696C28746869732E76616C7565292C733D';
wwv_flow_api.g_varchar2_table(72) := '7365744D73672873657474696E67732E6572726F724D73672C226E6F7420612076616C696420652D6D61696C206164647265737322293B627265616B3B636173652275726C223A743D76616C696461746F72732E697355726C28746869732E76616C7565';
wwv_flow_api.g_varchar2_table(73) := '292C733D7365744D73672873657474696E67732E6572726F724D73672C226E6F7420612076616C69642055524C22293B627265616B3B636173652264617465223A743D76616C696461746F72732E69734461746528746869732E76616C75652C73657474';
wwv_flow_api.g_varchar2_table(74) := '696E67732E64617465466F726D6174292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C226E6F7420612076616C69642064617465202826312922292C73657474696E67732E64617465466F72';
wwv_flow_api.g_varchar2_table(75) := '6D6174293B627265616B3B64656661756C743A7D217426267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E737461';
wwv_flow_api.g_varchar2_table(76) := '6E74732E6974656D54797065436C6173732C2131292C73686F774D65737361676528746869732C7329293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E6974656D54797065436C6173732C2130292C686964';
wwv_flow_api.g_varchar2_table(77) := '654D657373616765287468697329297D7D66756E6374696F6E20636861724C656E67746848616E646C657228297B76617220742C733B616C6C6F7756616C69646174696F6E28746869732C636F6E7374616E74732E636861724C656E677468436C617373';
wwv_flow_api.g_varchar2_table(78) := '29262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C69646174696F6E4D696E4C656E6774682926262876616C696461746F72732E6973456D7074792873657474696E67732E6D6178293F';
wwv_flow_api.g_varchar2_table(79) := '28743D76616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E6D696E292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C2276616C7565206C65';
wwv_flow_api.g_varchar2_table(80) := '6E67746820746F6F2073686F7274202D206D696E2E20263122292C73657474696E67732E6D696E29293A76616C696461746F72732E6973456D7074792873657474696E67732E6D696E293F28743D76616C696461746F72732E6D61784C656E6774682874';
wwv_flow_api.g_varchar2_table(81) := '6869732E76616C75652C73657474696E67732E6D6178292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C2276616C7565206C656E67746820746F6F206C6F6E67202D206D61782E2026312229';
wwv_flow_api.g_varchar2_table(82) := '2C73657474696E67732E6D617829293A28743D76616C696461746F72732E72616E67654C656E67746828746869732E76616C75652C73657474696E67732E6D696E2C73657474696E67732E6D6178292C733D7265706C6163654D73675661727328736574';
wwv_flow_api.g_varchar2_table(83) := '4D73672873657474696E67732E6572726F724D73672C22696E76616C69642076616C7565206C656E677468202D206265747765656E20263120616E64202632206F6E6C7922292C73657474696E67732E6D696E2C73657474696E67732E6D617829292C21';
wwv_flow_api.g_varchar2_table(84) := '7426267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E636861724C656E677468436C6173732C21';
wwv_flow_api.g_varchar2_table(85) := '31292C73686F774D65737361676528746869732C7329293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E636861724C656E677468436C6173732C2130292C686964654D65737361676528746869732929297D';
wwv_flow_api.g_varchar2_table(86) := '66756E6374696F6E206E756D62657253697A6548616E646C657228297B76617220742C732C653D7574696C2E6765744E756D62657246726F6D537472696E6728746869732E76616C7565292C693D7574696C2E6765744E756D62657246726F6D53747269';
wwv_flow_api.g_varchar2_table(87) := '6E67287574696C2E676574506167654974656D56616C75652873657474696E67732E6D696E29292C613D7574696C2E6765744E756D62657246726F6D537472696E67287574696C2E676574506167654974656D56616C75652873657474696E67732E6D61';
wwv_flow_api.g_varchar2_table(88) := '7829293B616C6C6F7756616C69646174696F6E28746869732C636F6E7374616E74732E6E756D62657253697A65436C61737329262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C696461';
wwv_flow_api.g_varchar2_table(89) := '74696F6E4D696E4C656E6774682926262876616C696461746F72732E6973456D7074792873657474696E67732E6D6178293F28743D76616C696461746F72732E6D696E4E756D62657228652C69292C733D7265706C6163654D736756617273287365744D';
wwv_flow_api.g_varchar2_table(90) := '73672873657474696E67732E6572726F724D73672C226E756D62657220746F6F20736D616C6C202D206D696E2E20263122292C6929293A76616C696461746F72732E6973456D7074792873657474696E67732E6D696E293F28743D76616C696461746F72';
wwv_flow_api.g_varchar2_table(91) := '732E6D61784E756D62657228652C61292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C226E756D62657220746F6F206C61726765202D206D61782E20263122292C6129293A28743D76616C69';
wwv_flow_api.g_varchar2_table(92) := '6461746F72732E72616E67654E756D62657228652C692C61292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C22696E76616C6964206E756D6265722073697A65202D206265747765656E2026';
wwv_flow_api.g_varchar2_table(93) := '3120616E64202632206F6E6C7922292C692C6129292C217426267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E73';
wwv_flow_api.g_varchar2_table(94) := '74616E74732E6E756D62657253697A65436C6173732C2131292C73686F774D65737361676528746869732C7329293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E6E756D62657253697A65436C6173732C21';
wwv_flow_api.g_varchar2_table(95) := '30292C686964654D65737361676528746869732929297D66756E6374696F6E20746F74616C436865636B656448616E646C657228297B76617220742C732C653D242874686973292E66696E6428223A636865636B626F782C203A726164696F22293B616C';
wwv_flow_api.g_varchar2_table(96) := '6C6F7756616C69646174696F6E28746869732C636F6E7374616E74732E746F74616C436865636B6564436C6173732926262876616C696461746F72732E6973456D7074792873657474696E67732E6D6178293F28743D76616C696461746F72732E6D696E';
wwv_flow_api.g_varchar2_table(97) := '436865636B28652C73657474696E67732E6D696E2C2130292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C22706C656173652073656C656374206174206C656173742026312063686F696365';
wwv_flow_api.g_varchar2_table(98) := '28732922292C73657474696E67732E6D696E29293A76616C696461746F72732E6973456D7074792873657474696E67732E6D696E293F28743D76616C696461746F72732E6D6178436865636B28652C73657474696E67732E6D6178292C733D7265706C61';
wwv_flow_api.g_varchar2_table(99) := '63654D736756617273287365744D73672873657474696E67732E6572726F724D73672C22706C656173652073656C656374206E6F206D6F7265207468616E2026312063686F69636528732922292C73657474696E67732E6D617829293A28743D76616C69';
wwv_flow_api.g_varchar2_table(100) := '6461746F72732E72616E6765436865636B28652C73657474696E67732E6D696E2C73657474696E67732E6D6178292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C22706C656173652073656C';
wwv_flow_api.g_varchar2_table(101) := '656374206265747765656E20263120616E642026322063686F69636528732922292C73657474696E67732E6D696E2C73657474696E67732E6D617829292C217426267574696C2E676574436F6E646974696F6E526573756C742873657474696E67732E63';
wwv_flow_api.g_varchar2_table(102) := '6F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E746F74616C436865636B6564436C6173732C2131292C73686F774D65737361676528746869732C7329293A2873657456616C69646174';
wwv_flow_api.g_varchar2_table(103) := '696F6E526573756C7428746869732C636F6E7374616E74732E746F74616C436865636B6564436C6173732C2130292C686964654D65737361676528746869732929297D66756E6374696F6E20646174654F7264657248616E646C657228297B7661722074';
wwv_flow_api.g_varchar2_table(104) := '2C732C653D7574696C2E676574506167654974656D56616C75652873657474696E67732E6D696E292C693D7574696C2E676574506167654974656D56616C75652873657474696E67732E6D6178293B616C6C6F7756616C69646174696F6E28746869732C';
wwv_flow_api.g_varchar2_table(105) := '636F6E7374616E74732E646174654F72646572436C61737329262676616C696461746F72732E6D696E4C656E67746828746869732E76616C75652C73657474696E67732E76616C69646174696F6E4D696E4C656E6774682926262876616C696461746F72';
wwv_flow_api.g_varchar2_table(106) := '732E6973456D7074792873657474696E67732E6D6178293F28743D76616C696461746F72732E6D696E4461746528746869732E76616C75652C652C73657474696E67732E64617465466F726D6174292C733D7265706C6163654D73675661727328736574';
wwv_flow_api.g_varchar2_table(107) := '4D73672873657474696E67732E6572726F724D73672C227468697320646174652073686F756C64206C696520616674657220263122292C6529293A76616C696461746F72732E6973456D7074792873657474696E67732E6D696E293F28743D76616C6964';
wwv_flow_api.g_varchar2_table(108) := '61746F72732E6D61784461746528746869732E76616C75652C692C73657474696E67732E64617465466F726D6174292C733D7265706C6163654D736756617273287365744D73672873657474696E67732E6572726F724D73672C22746869732064617465';
wwv_flow_api.g_varchar2_table(109) := '2073686F756C64206C6965206265666F726520263122292C6929293A28743D76616C696461746F72732E72616E67654461746528746869732E76616C75652C652C692C73657474696E67732E64617465466F726D6174292C733D7265706C6163654D7367';
wwv_flow_api.g_varchar2_table(110) := '56617273287365744D73672873657474696E67732E6572726F724D73672C227468697320646174652073686F756C64206C6965206265747765656E20263120616E6420263222292C652C6929292C217426267574696C2E676574436F6E646974696F6E52';
wwv_flow_api.g_varchar2_table(111) := '6573756C742873657474696E67732E636F6E646974696F6E293F2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E646174654F72646572436C6173732C2131292C73686F774D65737361676528746869732C7329';
wwv_flow_api.g_varchar2_table(112) := '293A2873657456616C69646174696F6E526573756C7428746869732C636F6E7374616E74732E646174654F72646572436C6173732C2130292C686964654D65737361676528746869732929297D66756E6374696F6E2073686F774D65737361676528742C';
wwv_flow_api.g_varchar2_table(113) := '73297B76617220653D242874292C693D273C7370616E20636C6173733D22272B636F6E7374616E74732E6572726F724D7367436C6173732B2220222B742E69642B27223E272B732B223C2F7370616E3E223B696628652E686173436C61737328636F6E73';
wwv_flow_api.g_varchar2_table(114) := '74616E74732E6974656D4572726F72436C61737329297B76617220613D2428227370616E2E222B636F6E7374616E74732E6572726F724D7367436C6173732B222E222B742E6964292C6E3D612E696E64657828292C723D652E696E64657828293B723E6E';
wwv_flow_api.g_varchar2_table(115) := '262673657474696E67732E6572726F724D73674C6F636174696F6E3D3D3D226265666F7265223F612E746578742873293A723E6E262673657474696E67732E6572726F724D73674C6F636174696F6E3D3D3D226166746572223F28612E72656D6F766528';
wwv_flow_api.g_varchar2_table(116) := '292C652E6166746572286929293A6E3E72262673657474696E67732E6572726F724D73674C6F636174696F6E3D3D3D226166746572223F612E746578742873293A28612E72656D6F766528292C652E6265666F7265286929297D656C736520652E616464';
wwv_flow_api.g_varchar2_table(117) := '436C61737328636F6E7374616E74732E6974656D4572726F72436C617373292C2428225B666F723D222B742E69642B225D22292E616464436C61737328636F6E7374616E74732E6C6162656C4572726F72436C617373292C73657474696E67732E657272';
wwv_flow_api.g_varchar2_table(118) := '6F724D73674C6F636174696F6E3D3D3D226265666F7265223F652E6265666F72652869293A652E61667465722869297D66756E6374696F6E20686964654D6573736167652874297B76617220733D242874293B732E686173436C61737328636F6E737461';
wwv_flow_api.g_varchar2_table(119) := '6E74732E6974656D4572726F72436C61737329262628732E72656D6F7665436C61737328636F6E7374616E74732E6974656D4572726F72436C617373292C2428225B666F723D222B742E69642B225D22292E72656D6F7665436C61737328636F6E737461';
wwv_flow_api.g_varchar2_table(120) := '6E74732E6C6162656C4572726F72436C617373292C2428227370616E2E222B636F6E7374616E74732E6572726F724D7367436C6173732B222E222B742E6964292E72656D6F76652829297D66756E6374696F6E207365744D736728742C73297B72657475';
wwv_flow_api.g_varchar2_table(121) := '726E2076616C696461746F72732E6973456D7074792874293F733A747D66756E6374696F6E207265706C6163654D7367566172732874297B666F722876617220733D742C653D312C693D617267756D656E74732E6C656E6774683B693E653B652B2B2973';
wwv_flow_api.g_varchar2_table(122) := '3D732E7265706C616365282226222B652C617267756D656E74735B655D293B72657475726E20737D66756E6374696F6E2073657456616C69646174696F6E526573756C7428742C732C65297B242874292E6461746128732C65297D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(123) := '6B657945786973747328742C73297B72657475726E20242874292E64617461287329213D3D766F696420307D66756E6374696F6E20616C6C6F7756616C69646174696F6E28742C73297B76617220653D21302C693D242874293B72657475726E206B6579';
wwv_flow_api.g_varchar2_table(124) := '45786973747328742C73293F242E6561636828692E6461746128292C66756E6374696F6E2874297B742E737562737472696E6728302C33293D3D3D636F6E7374616E74732E706C7567696E5072656669782626692E72656D6F7665446174612874297D29';
wwv_flow_api.g_varchar2_table(125) := '3A242E6561636828692E6461746128292C66756E6374696F6E28742C73297B742E737562737472696E6728302C33293D3D3D636F6E7374616E74732E706C7567696E5072656669782626653D3D3D2130262628653D73297D292C73657456616C69646174';
wwv_flow_api.g_varchar2_table(126) := '696F6E526573756C7428742C732C2130292C657D66756E6374696F6E20666F726D4861734572726F72732874297B76617220732C652C692C613D21312C6E3D242874292C723D6E2E66696E642822696E7075742C2074657874617265612C2073656C6563';
wwv_flow_api.g_varchar2_table(127) := '742C206669656C6473657422293B72657475726E20242E6561636828722C66756E6374696F6E28297B733D242874686973292C653D732E6461746128226576656E747322292C65213D3D766F696420302626242E6561636828652C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(128) := '74297B693D742C242E6561636828746869732C66756E6374696F6E28742C65297B652E6E616D6573706163653D3D3D636F6E7374616E74732E706C7567696E5072656669782626732E7472696767657228692B222E222B636F6E7374616E74732E706C75';
wwv_flow_api.g_varchar2_table(129) := '67696E507265666978297D297D297D292C722E686173436C61737328636F6E7374616E74732E6974656D4572726F72436C61737329262628242872292E66696C74657228222E222B636F6E7374616E74732E6974656D4572726F72436C617373292E6669';
wwv_flow_api.g_varchar2_table(130) := '72737428292E666F63757328292C613D2130292C617D66756E6374696F6E2076616C6964617465466F726D4265666F72655375626D69742870466972696E67456C656D297B76617220666972696E67456C656D3D242870466972696E67456C656D292C6F';
wwv_flow_api.g_varchar2_table(131) := '726967436C69636B4576656E744B65793D636F6E7374616E74732E706C7567696E5072656669782B222D222B226F726967436C69636B4576656E74222C6F726967436C69636B4576656E742C6669784572726F72734D73673D7365744D73672873657474';
wwv_flow_api.g_varchar2_table(132) := '696E67732E6572726F724D73672C22506C656173652066697820616C6C206572726F7273206265666F726520636F6E74696E75696E6722292C6D657373616765426F7849643D2223616C762D6D73672D626F78222C6D7367426F783D273C64697620636C';
wwv_flow_api.g_varchar2_table(133) := '6173733D22616C762D616C6572742D6D7367223E3C6120687265663D22232220636C6173733D22616C762D636C6F736522206F6E636C69636B3D2224285C27272B6D657373616765426F7849642B2227292E6368696C6472656E28292E666164654F7574';
wwv_flow_api.g_varchar2_table(134) := '28293B72657475726E2066616C73653B5C223E783C2F613E3C703E222B6669784572726F72734D73672B223C2F703E3C2F6469763E223B666972696E67456C656D2E6C656E677468262628666972696E67456C656D2E70726F7028227461674E616D6522';
wwv_flow_api.g_varchar2_table(135) := '293D3D3D22425554544F4E223F286F726967436C69636B4576656E743D666972696E67456C656D2E6174747228226F6E636C69636B22292C666972696E67456C656D2E64617461286F726967436C69636B4576656E744B65792C6F726967436C69636B45';
wwv_flow_api.g_varchar2_table(136) := '76656E74292C666972696E67456C656D2E72656D6F76654174747228226F6E636C69636B2229293A286F726967436C69636B4576656E743D666972696E67456C656D2E6174747228226872656622292C666972696E67456C656D2E64617461286F726967';
wwv_flow_api.g_varchar2_table(137) := '436C69636B4576656E744B65792C6F726967436C69636B4576656E74292C666972696E67456C656D2E72656D6F7665417474722822687265662229292C666972696E67456C656D2E6F6E2822636C69636B222C66756E6374696F6E28297B666F726D4861';
wwv_flow_api.g_varchar2_table(138) := '734572726F72732873657474696E67732E666F726D73546F5375626D6974293F2824286D657373616765426F784964292E6C656E6774687C7C242822626F647922292E617070656E6428273C6469762069643D22272B6D657373616765426F7849642E73';
wwv_flow_api.g_varchar2_table(139) := '7562737472696E672831292B27223E3C2F6469763E27292C24286D657373616765426F784964292E68746D6C286D7367426F7829293A6576616C28242874686973292E64617461286F726967436C69636B4576656E744B657929297D29297D7661722063';
wwv_flow_api.g_varchar2_table(140) := '6F6E7374616E74733D7B706C7567696E49643A2262652E6374622E6A712E616C76222C706C7567696E4E616D653A2241504558204C6976652056616C69646174696F6E222C706C7567696E5072656669783A22616C76222C73656C6563746F723A746869';
wwv_flow_api.g_varchar2_table(141) := '732E73656C6563746F722C61706578436865636B626F78436C6173733A22636865636B626F785F67726F7570222C61706578526164696F436C6173733A22726164696F5F67726F7570222C6170657853687574746C65436C6173733A2273687574746C65';
wwv_flow_api.g_varchar2_table(142) := '227D3B242E657874656E6428636F6E7374616E74732C7B6E6F74456D707479436C6173733A636F6E7374616E74732E706C7567696E5072656669782B222D222B226E6F74456D707479222C6974656D54797065436C6173733A636F6E7374616E74732E70';
wwv_flow_api.g_varchar2_table(143) := '6C7567696E5072656669782B222D222B226974656D54797065222C657175616C436C6173733A636F6E7374616E74732E706C7567696E5072656669782B222D222B22657175616C222C7265676578436C6173733A636F6E7374616E74732E706C7567696E';
wwv_flow_api.g_varchar2_table(144) := '5072656669782B222D222B227265676578222C636861724C656E677468436C6173733A636F6E7374616E74732E706C7567696E5072656669782B222D222B22636861724C656E677468222C6E756D62657253697A65436C6173733A636F6E7374616E7473';
wwv_flow_api.g_varchar2_table(145) := '2E706C7567696E5072656669782B222D222B226E756D62657253697A65222C646174654F72646572436C6173733A636F6E7374616E74732E706C7567696E5072656669782B222D222B22646174654F72646572222C746F74616C436865636B6564436C61';
wwv_flow_api.g_varchar2_table(146) := '73733A636F6E7374616E74732E706C7567696E5072656669782B222D222B22746F74616C436865636B6564222C6974656D4572726F72436C6173733A22616C762D6974656D2D6572726F72222C6C6162656C4572726F72436C6173733A22616C762D6C61';
wwv_flow_api.g_varchar2_table(147) := '62656C2D6572726F72222C6572726F724D7367436C6173733A22616C762D6572726F722D6D7367227D293B7661722073657474696E67733D7B76616C69646174653A226E6F74456D707479222C74726967676572696E674576656E743A22626C7572222C';
wwv_flow_api.g_varchar2_table(148) := '636F6E646974696F6E3A22222C76616C69646174696F6E4D696E4C656E6774683A302C6572726F724D73673A22222C6572726F724D73674C6F636174696F6E3A226166746572222C616C6C6F77576869746573706163653A21302C6974656D547970653A';
wwv_flow_api.g_varchar2_table(149) := '22222C64617465466F726D61743A22222C6D696E3A22222C6D61783A22222C657175616C3A22222C72656765783A22222C666F726D73546F5375626D69743A22227D2C6D6574686F64733D7B696E69743A66756E6374696F6E2874297B76617220733D24';
wwv_flow_api.g_varchar2_table(150) := '2874686973293B62696E6453657474696E677328732C74292C696E69742873297D2C76616C6964617465466F726D3A66756E6374696F6E2874297B76617220733D242874686973293B62696E6453657474696E677328732C74292C76616C696461746546';
wwv_flow_api.g_varchar2_table(151) := '6F726D4265666F72655375626D69742873297D2C72656D6F76653A66756E6374696F6E28297B76617220743D242874686973293B726573746F7265506C7567696E53657474696E677328742926266D6574686F6428297D7D3B72657475726E2024287468';
wwv_flow_api.g_varchar2_table(152) := '6973292E656163682866756E6374696F6E28297B72657475726E206D6574686F64735B6D6574686F645D3F6D6574686F64735B6D6574686F645D2E63616C6C28242874686973292C6F7074696F6E73293A747970656F66206D6574686F64213D226F626A';
wwv_flow_api.g_varchar2_table(153) := '6563742226266D6574686F643F28242E6572726F7228224D6574686F6420222B6D6574686F642B2220646F6573206E6F74206578697374206F6E206A51756572792E20222B636F6E7374616E74732E706C7567696E4E616D65292C2131293A6D6574686F';
wwv_flow_api.g_varchar2_table(154) := '64732E696E69742E63616C6C28242874686973292C6D6574686F64297D297D7D286A51756572792C616C762E7574696C2C616C762E76616C696461746F727329';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 23372442408979508919 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 90133455934278868091 + wwv_flow_api.g_id_offset
 ,p_file_name => 'jquery.alv.js'
 ,p_mime_type => 'text/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
