"use strict";

/**
 * @namespace The namespace for the APEX Live Validation (ALV) plugin.
 */
var alv = {};


/**
 * @namespace Utility module.
 */
alv.util = {
    jQuery: $,

    /**
     * @description Trim leading and trailing whitespace characters from a string value.
     * @param {String} pVal The value which you want to trim.
     * @returns {String} The trimmed value.
     */
    trim: function (pVal) {
        return pVal.replace(/^\s+|\s+$/g, "");
    },
    /**
     * @description Get the value of a page item if an ID selector is passed as parameter, otherwise return the parameter value.
     * @param {String} pItem Can be either an APEX page item ID selector or a statically defined value.
     * @returns {String} The value of the page item or the statically defined value.
     */
    getPageItemValue: function (pItem) {
        if (pItem.substring(0, 2) === "#P") {
            return $(pItem).val();
        } else {
            return pItem;
        }
    },
    /**
     * @description Get the result of JavaScript condition.
     * @param {String} pCondition A JavaScript expression in the form of a string that will be evaluated with eval().
     * @returns {Boolean} The boolean result of the expression.
     */
    getConditionResult: function (pCondition) {
        if (pCondition.length !== 0) {
            return eval(pCondition);
        } else {
            return true;
        }
    },
    /**
     * @description Format a DD/MM/YYYY date represented as a string to a date object.
     * @param {String} pVal The date value as a string.
     * @returns {Date} The date value as a date object.
     */
    getDateFromString: function (pVal) {
        var dateArray = pVal.split("/");
        var year = parseInt(dateArray[2]);
        var month = parseInt(dateArray[1], 10);
        var day = parseInt(dateArray[0], 10);

        return new Date(year, month - 1, day);
    },
    /**
     * @description Convert a string date in a specific format to the DD/MM/YYYY date format.
     * @param {String} pDate The date that has to be converted.
     * @param {String} pDateFormat The date format of pDate.
     * @returns {String} The date value in the DD/MM/YYYY format.
     */
    convertDate: function (pDate, pDateFormat) {
        var dayPart;
        var monthPart;
        var yearPart;
        var dateSeparator;
        var dateFormatSeparator;
        var dateFormat = pDateFormat.toUpperCase();

        dateSeparator = pDate.replace(/\d+/g, "");
        dateFormatSeparator = dateFormat.replace(/[A-Z]+/g, "");

        if (pDate.length === pDateFormat.length || dateSeparator === dateFormatSeparator) {
            if (dateFormat.indexOf("DD") === -1) {
                dayPart = "xx";
            } else {
                dayPart = pDate.substring(dateFormat.indexOf("DD"), dateFormat.indexOf("DD") + 2);
            }

            if (dateFormat.indexOf("MM") === -1) {
                monthPart = "xx";
            } else {
                monthPart = pDate.substring(dateFormat.indexOf("MM"), dateFormat.indexOf("MM") + 2);
            }

            if (dateFormat.indexOf("YYYY") === -1) {
                if (dateFormat.indexOf("RRRR") === -1) {
                    if (dateFormat.indexOf("YY") === -1) {
                        if (dateFormat.indexOf("RR") === -1) {
                            yearPart = "xxxx";
                        } else {
                            yearPart = pDate.substring(dateFormat.indexOf("RR"), dateFormat.indexOf("RR") + 2);
                        }
                    } else {
                        yearPart = pDate.substring(dateFormat.indexOf("YY"), dateFormat.indexOf("YY") + 2);
                    }
                } else {
                    yearPart = pDate.substring(dateFormat.indexOf("RRRR"), dateFormat.indexOf("RRRR") + 4);
                }
            } else {
                yearPart = pDate.substring(dateFormat.indexOf("YYYY"), dateFormat.indexOf("YYYY") + 4);
            }
        }

        return dayPart + "/" + monthPart + "/" + yearPart;
    }
};


/**
 * @namespace Validators module.
 */
alv.validators = {
    jQuery: $,
    util: alv.util,

    /**
     * @description Validate whether a value is empty.
     * @param {String|Number|RegExp} pVal The value to be tested.
     * @returns {Boolean}
     */
    isEmpty: function (pVal) {
        return pVal === "";
    },
    /**
     * @description Check for equal values between two parameters.
     * @param {String} pVal The first value.
     * @param {String} pVal2 The second value.
     * @returns {Boolean}
     */
    isEqual: function (pVal, pVal2) {
        return pVal === pVal2;
    },
    /**
     * @description Validate whether a value matches a regular expression.
     * @param {String} pVal The value to be tested.
     * @param {RegExp} pRegex The regular expression.
     * @returns {Boolean}
     */
    regex: function (pVal, pRegex) {
        return new RegExp(pRegex).test(pVal) || this.isEmpty(pVal);
    },

    /**
     * @description Validate whether a value contains only alphanumeric characters.
     * @param {String} pVal The value to be tested.
     * @returns {Boolean}
     */
    isAlphanumeric: function (pVal) {
        return this.regex(pVal, /^[a-z0-9]+$/i);
    },
    /**
     * @description Validate whether a value is a valid number.
     * @param {String} pVal The value to be tested.
     * @returns {Boolean}
     */
    isNumber: function (pVal) {
        return this.regex(pVal, /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/);
    },
    /**
     * @description Validate whether a value contains only digit characters.
     * @param {String} pVal The value to be tested.
     * @returns {Boolean}
     */
    isDigit: function (pVal) {
        return this.regex(pVal, /^\d+$/);
    },
    /**
     * @description Validate whether a value is a valid e-mail address.
     * @param {String} pVal The value to be tested.
     * @returns {Boolean}
     */
    isEmail: function (pVal) {
        return this.regex(pVal, /^[^\s@]+@[^\s@]+\.[^\s@]+$/);
    },
    /**
     * @description Validate whether a value is a valid URL.
     * @param {String} pVal The value to be tested.
     * @returns {Boolean}
     */
    isUrl: function (pVal) {
        return this.regex(pVal, /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/);
    },
    /**
     * @description Validate whether a value is a valid date.
     * @param {String} pVal The value to be tested.
     * @param {String} pDateFormat The date format of pVal.
     * @returns {Boolean}
     */
    isDate: function (pVal, pDateFormat) {
        var isValidDate = false;
        var convertedDate = this.util.convertDate(pVal, pDateFormat);
        var dateFormatRegex = new RegExp("^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(?:[0-9]{2})?[0-9]{2}$");

        if (convertedDate.match(dateFormatRegex)) {
            var dateArray = convertedDate.split("/");
            var year = parseInt(dateArray[2]);
            var month = parseInt(dateArray[1], 10);
            var day = parseInt(dateArray[0], 10);
            var date = new Date(year, month - 1, day);

            if (((date.getMonth() + 1) === month) && (date.getDate() === day) && (date.getFullYear() === year)) {
                isValidDate = true;
            }
        }
        return isValidDate || this.isEmpty(pVal);
    },

    /**
     * @description Validate whether the character length of a value is not lower than the minimum character length.
     * @param {String} pVal The value to be tested.
     * @param {Number} pMin The minimum character length.
     * @returns {Boolean}
     */
    minLength: function (pVal, pMin) {
        return pVal.length >= pMin || this.isEmpty(pVal);
    },
    /**
     * @description Validate whether the character length of a value is not higher than the maximum character length.
     * @param {String} pVal The value to be tested.
     * @param {Number} pMax The maximum character length.
     * @returns {Boolean}
     */
    maxLength: function (pVal, pMax) {
        return pVal.length <= pMax || this.isEmpty(pVal);
    },
    /**
     * @description Validate whether the character length of a value lies between the minimum and maximum character length.
     * @param {String} pVal The value to be tested.
     * @param {Number} pMin The minimum character length.
     * @param {Number} pMax The maximum character length.
     * @returns {Boolean}
     */
    rangeLength: function (pVal, pMin, pMax) {
        return this.minLength(pVal, pMin) && this.maxLength(pVal, pMax) || this.isEmpty(pVal);
    },

    /**
     * @description Validate whether a number is not lower than the minimum number.
     * @param {Number} pVal The value to be tested.
     * @param {Number} pMin The minimum number.
     * @returns {Boolean}
     */
    minNumber: function (pVal, pMin) {
        return pVal >= pMin || this.isEmpty(pVal);
    },
    /**
     * @description Validate whether a number is not higher than the maximum number.
     * @param {Number} pVal The value to be tested.
     * @param {Number} pMax The maximum number.
     * @returns {Boolean}
     */
    maxNumber: function (pVal, pMax) {
        return pVal <= pMax || this.isEmpty(pVal);
    },
    /**
     * @description Validate whether a number lies between the minimum and maximum number.
     * @param {Number} pVal The value to be tested.
     * @param {Number} pMin The minimum number.
     * @param {Number} pMax The maximum number.
     * @returns {Boolean}
     */
    rangeNumber: function (pVal, pMin, pMax) {
        return this.minNumber(pVal, pMin) && this.maxNumber(pVal, pMax) || this.isEmpty(pVal);
    },

    /**
     * @description Validate whether the amount of selected checkboxes is not lower than the minimum boundary.
     * @param {String} pChoices The ID selector of the checkbox group that will be validated.
     * @param {Number} pMin The minimum amount of selected checkboxes.
     * @param {Boolean} pEmptyAllowed Indicate whether it is allowed to have no checkbox selected.
     * @returns {Boolean}
     */
    minCheck: function (pChoices, pMin, pEmptyAllowed) {
        var totalChecked = $(pChoices).filter(':checked').length;

        if (pEmptyAllowed) {
            return this.minNumber(totalChecked, pMin) || totalChecked === 0;
        } else {
            return this.minNumber(totalChecked, pMin);
        }
    },
    /**
     * @description Validate whether the amount of selected checkboxes is not higher than the maximum boundary.
     * @param {String} pChoices The ID selector of the checkbox group that will be validated.
     * @param {Number} pMax The maximum amount of selected checkboxes.
     * @returns {Boolean}
     */
    maxCheck: function (pChoices, pMax) {
        var totalChecked = $(pChoices).filter(':checked').length;
        return this.maxNumber(totalChecked, pMax) || totalChecked === 0;
    },
    /**
     * @description Validate whether the amount of selected checkboxes lies between the minimum and maximum boundary.
     * @param {String} pChoices The ID selector of the checkbox group that will be validated.
     * @param {Number} pMin The minimum amount of selected checkboxes.
     * @param {Number} pMax The maximum amount of selected checkboxes.
     * @returns {Boolean}
     */
    rangeCheck: function (pChoices, pMin, pMax) {
        var totalChecked = $(pChoices).filter(':checked').length;
        return this.rangeNumber(totalChecked, pMin, pMax) || totalChecked === 0;
    },

    /**
     * @description Validate whether a given date is not lower than the minimum date.
     * @param {String} pVal The date to be tested.
     * @param {String} pMin The minimum date.
     * @param {String} pDateFormat The date format.
     * @returns {Boolean}
     */
    minDate: function (pVal, pMin, pDateFormat) {
        var date = new Date();
        var minimumDate = new Date();

        if (!this.isEmpty(pVal) && !this.isEmpty(pMin)) {
            if (this.isDate(pVal, pDateFormat) && this.isDate(pMin, pDateFormat)) {
                date = this.util.getDateFromString(this.util.convertDate(pVal, pDateFormat));
                minimumDate = this.util.getDateFromString(this.util.convertDate(pMin, pDateFormat));

                return date >= minimumDate;
            }
        }
        return true;
    },
    /**
     * @description Validate whether a given date is not higher than the maximum date.
     * @param {String} pVal The date to be tested.
     * @param {String} pMax The maximum date.
     * @param {String} pDateFormat The date format.
     * @returns {Boolean}
     */
    maxDate: function (pVal, pMax, pDateFormat) {
        var date = new Date();
        var maximumDate = new Date();

        if (!this.isEmpty(pVal) && !this.isEmpty(pMax)) {
            if (this.isDate(pVal, pDateFormat) && this.isDate(pMax, pDateFormat)) {
                date = this.util.getDateFromString(this.util.convertDate(pVal, pDateFormat));
                maximumDate = this.util.getDateFromString(this.util.convertDate(pMax, pDateFormat));

                return date <= maximumDate;
            }
        }
        return true;
    },
    /**
     * @description Validate whether a given date lies between the minimum and maximum date.
     * @param {String} pVal The date to be tested.
     * @param {String} pMin The minimum date.
     * @param {String} pMax The maximum date.
     * @param {String} pDateFormat The date format.
     * @returns {Boolean}
     */
    rangeDate: function (pVal, pMin, pMax, pDateFormat) {
        var date = new Date();
        var minimumDate = new Date();
        var maximumDate = new Date();

        if (!this.isEmpty(pVal) && !this.isEmpty(pMin) && !this.isEmpty(pMax)) {
            if (this.isDate(pVal, pDateFormat) && this.isDate(pMin, pDateFormat) && this.isDate(pMax, pDateFormat)) {
                date = this.util.getDateFromString(this.util.convertDate(pVal, pDateFormat));
                minimumDate = this.util.getDateFromString(this.util.convertDate(pMin, pDateFormat));
                maximumDate = this.util.getDateFromString(this.util.convertDate(pMax, pDateFormat));

                if (minimumDate > maximumDate) {
                    return true;
                }

                return date >= minimumDate && date <= maximumDate;
            }
        }
        return true;
    }
};



/**
 * @namespace The APEX Live Validation jQuery plugin.
 */
(function ($, util, validators) {
    "use strict";

    $.fn.alv = function (method, options) {

        var constants = {
            'pluginId': "be.ctb.jq.alv",
            'pluginName': "APEX Live Validation",
            'pluginPrefix': "alv",

            // apex related
            'itemErrorClass': 'apex-page-item-error',
            'errorMsgClass': 'label-error',
            'apexCheckboxClass': 'checkbox_group',
            'apexRadioClass': 'radio_group',
            'apexShuttleClass': 'shuttle'
        };
        $.extend(constants, {
            // validation identifiers
            'notEmptyClass': constants.pluginPrefix + "-" + "notEmpty",
            'equalClass': constants.pluginPrefix + "-" + "equal",
            'regexClass': constants.pluginPrefix + "-" + "regex",
            'itemTypeClass': constants.pluginPrefix + "-" + "itemType",
            'charLengthClass': constants.pluginPrefix + "-" + "charLength",
            'numberSizeClass': constants.pluginPrefix + "-" + "numberSize",
            'dateOrderClass': constants.pluginPrefix + "-" + "dateOrder",
            'totalCheckedClass': constants.pluginPrefix + "-" + "totalChecked"
        });

        var settings = {
            'validate': 'notEmpty',
            'triggeringEvent': 'blur',
            'condition': '',
            'validationMinLength': 0,  // the amount of characters required before the validation is fired
            'errorMsg': '',
            'errorMsgLocation': 'before',
            'allowWhitespace': true,
            'itemType': '',
            'dateFormat': '',
            'min': '',
            'max': '',
            'equal': '',
            'regex': '',
            'formSubmitElems': ''
        };

        var methods = {
            init: function (options) {
                var element = $(this);
                bindSettings(element, options);
                init(element);
            },
            remove: function () {
                var element = $(this);
                if (restorePluginSettings(element)) {
                    method();
                }
            },
            validateForm: function (options) {
                var element = $(this);
                bindSettings(element, options);
                validateFormBeforeSubmit(element);
            }
        };

        function restorePluginSettings(element) {
            var elem = $(element);
            if (typeof elem.data(constants.pluginId) !== "undefined") {
                $.extend(settings, elem.data(constants.pluginId));
                return true;
            }
            return false;
        }

        function extendSettings(options) {
            if (options) {
                $.extend(settings, options);
            }
        }

        function bindSettings(element, options) {
            extendSettings(options);
            $(element).data(constants.pluginId, settings);
        }

        return $(this).each(function () {
            if (methods[method]) {
                return methods[method].call($(this), options);
            } else if (typeof method === 'object' || !method) {
                return methods.init.call($(this), method);
            } else {
                $.error('Method ' + method + ' does not exist on jQuery. ' + constants.pluginName);
                return false;
            }
        });

        function init(element) {
            var triggeringEvent = settings.triggeringEvent + '.' + constants.pluginPrefix;
            var changeEvent = 'change' + '.' + constants.pluginPrefix;

            switch (settings.validate) {
                case 'notEmpty':
                    if ($(element).hasClass(constants.apexCheckboxClass) ||
                        $(element).hasClass(constants.apexRadioClass) ||
                        $(element).hasClass(constants.apexShuttleClass) ||
                        $(element).prop('tagName') === 'SELECT' ||
                        $(element).attr('type') === 'file') {
                        if (settings.triggeringEvent !== 'change') {
                            triggeringEvent = triggeringEvent + ' ' + changeEvent;
                        }
                    }
                    element.on(triggeringEvent, isEmptyHandler);
                    break;
                case 'equal':
                    element.on(triggeringEvent, isEqualHandler);
                    break;
                case 'regex':
                    element.on(triggeringEvent, regexHandler);
                    break;
                case 'itemType':
                    element.on(triggeringEvent, itemTypeHandler);
                    break;
                case 'charLength':
                    element.on(triggeringEvent, charLengthHandler);
                    break;
                case 'numberSize':
                    element.on(triggeringEvent, numberSizeHandler);
                    break;
                case 'dateOrder':
                    element.on(triggeringEvent, dateOrderHandler);
                    break;
                case 'totalChecked':
                    element.on(changeEvent, totalCheckedHandler);
                    break;
                default:
            }
            return element;
        }


        // VALIDATION HANDLERS

        // general
        function isEmptyHandler() {
            var itemEmpty;
            var emptyMsg = setMsg(settings.errorMsg, "value required");

            if (allowValidation(this, constants.notEmptyClass)) {
                if ($(this).hasClass(constants.apexCheckboxClass) ||
                    $(this).hasClass(constants.apexRadioClass)) {
                    itemEmpty = !validators.minCheck($(this).find(':checkbox, :radio'), 1, false);
                } else if ($(this).hasClass(constants.apexShuttleClass)) {
                    itemEmpty = !$(this).find('select.shuttle_right').val();
                } else if ($(this).prop('tagName') === 'SELECT' || $(this).attr('type') === 'file') {
                    itemEmpty = validators.isEmpty(this.value);
                } else {
                    if (settings.allowWhitespace) {
                        itemEmpty = validators.isEmpty(this.value);
                    } else {
                        itemEmpty = validators.isEmpty(util.trim(this.value));
                    }
                }

                if (itemEmpty && util.getConditionResult(settings.condition)) {
                    setValidationResult(this, constants.notEmptyClass, false);
                    showMessage(this, emptyMsg);
                } else {
                    setValidationResult(this, constants.notEmptyClass, true);
                    hideMessage(this);
                }
            }
        }

        function isEqualHandler() {
            var equalMsg = setMsg(settings.errorMsg, "values do not equal");

            if (allowValidation(this, constants.equalClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    if (!validators.isEqual(this.value, $('#' + settings.equal).val()) && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.equalClass, false);
                        showMessage(this, equalMsg);
                    } else {
                        setValidationResult(this, constants.equalClass, true);
                        hideMessage(this);
                    }
                }
            }
        }

        function regexHandler() {
            var regexMsg = setMsg(settings.errorMsg, "invalid value");

            if (allowValidation(this, constants.regexClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    if (!validators.regex(this.value, settings.regex) && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.regexClass, false);
                        showMessage(this, regexMsg);
                    } else {
                        setValidationResult(this, constants.regexClass, true);
                        hideMessage(this);
                    }
                }
            }
        }

        // item types
        function itemTypeHandler() {
            var itemTypeOk;
            var itemTypeErrorMsg;

            if (allowValidation(this, constants.itemTypeClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    switch (settings.itemType) {
                        case 'alphanumeric':
                            itemTypeOk = validators.isAlphanumeric(this.value);
                            itemTypeErrorMsg = setMsg(settings.errorMsg, "not an alphanumeric value");
                            break;
                        case 'number':
                            itemTypeOk = validators.isNumber(this.value);
                            itemTypeErrorMsg = setMsg(settings.errorMsg, "not a valid number");
                            break;
                        case 'digit':
                            itemTypeOk = validators.isDigit(this.value);
                            itemTypeErrorMsg = setMsg(settings.errorMsg, "not a valid digit combination");
                            break;
                        case 'email':
                            itemTypeOk = validators.isEmail(this.value);
                            itemTypeErrorMsg = setMsg(settings.errorMsg, "not a valid e-mail address");
                            break;
                        case 'url':
                            itemTypeOk = validators.isUrl(this.value);
                            itemTypeErrorMsg = setMsg(settings.errorMsg, "not a valid URL");
                            break;
                        case 'date':
                            itemTypeOk = validators.isDate(this.value, settings.dateFormat);
                            itemTypeErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "not a valid date (&1)"), settings.dateFormat);
                            break;
                        default:
                    }

                    if (!itemTypeOk && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.itemTypeClass, false);
                        showMessage(this, itemTypeErrorMsg);
                    } else {
                        setValidationResult(this, constants.itemTypeClass, true);
                        hideMessage(this);
                    }
                }
            }
        }

        // strings
        function charLengthHandler() {
            var charLengthOk;
            var charLengthErrorMsg;

            if (allowValidation(this, constants.charLengthClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    if (validators.isEmpty(settings.max)) {
                        charLengthOk = validators.minLength(this.value, settings.min);
                        charLengthErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "value length too short - min. &1"), settings.min);
                    } else if (validators.isEmpty(settings.min)) {
                        charLengthOk = validators.maxLength(this.value, settings.max);
                        charLengthErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "value length too long - max. &1"), settings.max);
                    } else {
                        charLengthOk = validators.rangeLength(this.value, settings.min, settings.max);
                        charLengthErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "invalid value length - between &1 and &2 only"), settings.min, settings.max);
                    }

                    if (!charLengthOk && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.charLengthClass, false);
                        showMessage(this, charLengthErrorMsg);
                    } else {
                        setValidationResult(this, constants.charLengthClass, true);
                        hideMessage(this);
                    }
                }
            }
        }

        // numbers
        function numberSizeHandler() {
            var numberSizeOk;
            var numberSizeErrorMsg;
            var value = Number(this.value);
            var min = Number(util.getPageItemValue(settings.min));
            var max = Number(util.getPageItemValue(settings.max));

            if (allowValidation(this, constants.numberSizeClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    if (validators.isEmpty(settings.max)) {
                        numberSizeOk = validators.minNumber(value, min);
                        numberSizeErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "number too small - min. &1"), min);
                    } else if (validators.isEmpty(settings.min)) {
                        numberSizeOk = validators.maxNumber(value, max);
                        numberSizeErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "number too large - max. &1"), max);
                    } else {
                        numberSizeOk = validators.rangeNumber(value, min, max);
                        numberSizeErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "invalid number size - between &1 and &2 only"), min, max);
                    }

                    if (!numberSizeOk && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.numberSizeClass, false);
                        showMessage(this, numberSizeErrorMsg);
                    } else {
                        setValidationResult(this, constants.numberSizeClass, true);
                        hideMessage(this);
                    }
                }
            }
        }

        // checkboxes
        function totalCheckedHandler() {
            var totalCheckedOk;
            var totalCheckedErrorMsg;
            var choices = $(this).find(':checkbox, :radio');

            if (allowValidation(this, constants.totalCheckedClass)) {
                if (validators.isEmpty(settings.max)) {
                    totalCheckedOk = validators.minCheck(choices, settings.min, true);
                    totalCheckedErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "please select at least &1 choice(s)"), settings.min);
                } else if (validators.isEmpty(settings.min)) {
                    totalCheckedOk = validators.maxCheck(choices, settings.max);
                    totalCheckedErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "please select no more than &1 choice(s)"), settings.max);
                } else {
                    totalCheckedOk = validators.rangeCheck(choices, settings.min, settings.max);
                    totalCheckedErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "please select between &1 and &2 choice(s)"), settings.min, settings.max);
                }

                if (!totalCheckedOk && util.getConditionResult(settings.condition)) {
                    setValidationResult(this, constants.totalCheckedClass, false);
                    showMessage(this, totalCheckedErrorMsg);
                } else {
                    setValidationResult(this, constants.totalCheckedClass, true);
                    hideMessage(this);
                }
            }
        }

        // dates
        function dateOrderHandler() {
            var dateOrderOk;
            var dateOrderErrorMsg;
            var min = util.getPageItemValue(settings.min);
            var max = util.getPageItemValue(settings.max);

            if (allowValidation(this, constants.dateOrderClass)) {
                if (validators.minLength(this.value, settings.validationMinLength)) {
                    if (validators.isEmpty(settings.max)) {
                        dateOrderOk = validators.minDate(this.value, min, settings.dateFormat);
                        dateOrderErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "this date should lie after &1"), min);
                    } else if (validators.isEmpty(settings.min)) {
                        dateOrderOk = validators.maxDate(this.value, max, settings.dateFormat);
                        dateOrderErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "this date should lie before &1"), max);
                    } else {
                        dateOrderOk = validators.rangeDate(this.value, min, max, settings.dateFormat);
                        dateOrderErrorMsg = replaceMsgVars(setMsg(settings.errorMsg, "this date should lie between &1 and &2"), min, max);
                    }

                    if (!dateOrderOk && util.getConditionResult(settings.condition)) {
                        setValidationResult(this, constants.dateOrderClass, false);
                        showMessage(this, dateOrderErrorMsg);
                    } else {
                        setValidationResult(this, constants.dateOrderClass, true);
                        hideMessage(this);
                    }
                }
            }
        }


        // ERROR MESSAGE
        function showMessage(pElem, pMessage) {
            var inputElem = $(pElem);
            var errorMsgHtml = "<span class=\"" + constants.errorMsgClass + "\" data-alv-for=\"" + pElem.id + "\">" + pMessage + "</span>";

            if (inputElem.hasClass(constants.itemErrorClass)) {
                var errorMsgElem = inputElem.siblings('[data-alv-for=' + pElem.id + ']');
                var errorMsgElemIndex = errorMsgElem.index();
                var inputElemIndex = inputElem.index();

                if (errorMsgElemIndex < inputElemIndex && settings.errorMsgLocation === 'before') {
                    errorMsgElem.text(pMessage);
                } else if (errorMsgElemIndex < inputElemIndex && settings.errorMsgLocation === 'after') {
                    errorMsgElem.remove();
                    inputElem.after(errorMsgHtml);
                } else if (errorMsgElemIndex > inputElemIndex && settings.errorMsgLocation === 'after') {
                    errorMsgElem.text(pMessage);
                } else {
                    errorMsgElem.remove();
                    inputElem.before(errorMsgHtml);
                }
            } else {
                inputElem.addClass(constants.itemErrorClass);
                if (settings.errorMsgLocation === 'before') {
                    inputElem.before(errorMsgHtml);
                } else {
                    inputElem.after(errorMsgHtml);
                }
            }
        }

        function hideMessage(pElem) {
            var inputElem = $(pElem);

            if (inputElem.hasClass(constants.itemErrorClass)) {
                inputElem.removeClass(constants.itemErrorClass);
                inputElem.siblings('[data-alv-for=' + pElem.id + ']').remove();
            }
        }

        function setMsg(customMsg, defaultMsg) {
            if (customMsg !== "") {
                return customMsg;
            } else {
                return defaultMsg;
            }
        }

        function replaceMsgVars(pMessage) {
            var errorMsg = pMessage;

            for (var i = 1, j = arguments.length; i < j; i++) {
                errorMsg = errorMsg.replace("&" + i, arguments[i]);
            }
            return errorMsg;
        }


        // ERROR CONTROL
        function setValidationResult(pElem, pKey, pVal) {
            $(pElem).data(pKey, pVal);
        }

        function keyExists(pElem, pKey) {
            return typeof $(pElem).data(pKey) !== "undefined";
        }

        function allowValidation(pElem, pKey) {
            var allowValidation = true;
            var inputElem = $(pElem);

            if (!keyExists(pElem, pKey)) {
                $.each(inputElem.data(), function (key, val) {
                    if (key.substring(0, 3) === constants.pluginPrefix) {
                        if (allowValidation === true) {
                            allowValidation = val;
                        }
                    }
                });
            } else {
                $.each(inputElem.data(), function (key) {
                    if (key.substring(0, 3) === constants.pluginPrefix) {
                        inputElem.removeData(key);
                    }
                });
            }

            setValidationResult(pElem, pKey, true);
            return allowValidation;
        }


        // FORM VALIDATION
        function formHasErrors(pForm) {
            var formHasErrors = false;
            var form = $(pForm);
            var formElems = form.find('input, textarea, select, fieldset');
            var formElem;
            var formElemEvents;
            var event;

            $.each(formElems, function () {
                formElem = $(this);
                formElemEvents = formElem.data('events');
                if (typeof formElemEvents !== "undefined") {
                    $.each(formElemEvents, function (key) {
                        event = key;
                        $.each(this, function (key, value) {
                            if (value.namespace === constants.pluginPrefix) {
                                formElem.trigger(event + '.' + constants.pluginPrefix);
                            }
                        });
                    });
                }
            });

            $.each(formElems, function () {
                formElem = $(this);
                if (formElem.hasClass(constants.itemErrorClass)) {
                    formElem.focus();
                    formHasErrors = true;
                    return false;
                }
            });

            return formHasErrors;
        }

        function validateFormBeforeSubmit(pForm) {
            var origClickEventKey = constants.pluginPrefix + '-' + 'origClickEvent';
            var origClickEvent;
            var firingElem;

            var fixErrorsMsg = setMsg(settings.errorMsg, "Please fix all errors before continuing");
            var messageBoxId = "#alv-msg-box";
            var msgBox =      '<div class="alv-alert-msg">';
            msgBox = msgBox + '  <a href="#" class="alv-close" onclick="$(\'' + messageBoxId + '\').children().fadeOut();return false;">x</a>';
            msgBox = msgBox + '  <p>' + fixErrorsMsg + '</p>';
            msgBox = msgBox + '</div>';

            $.each(settings.formSubmitElems.split(","), function (index, item) {
                firingElem = $(item);

                if (firingElem.length !== 0) {
                    if (firingElem.prop('tagName') === 'BUTTON') {
                        origClickEvent = firingElem.attr('click');
                        firingElem.data(origClickEventKey, origClickEvent);
                        firingElem.removeAttr('click');
                    } else {
                        origClickEvent = firingElem.attr('href');
                        firingElem.data(origClickEventKey, origClickEvent);
                        firingElem.removeAttr('href');
                    }

                    firingElem.on('click', function () {
                        if (!formHasErrors(pForm)) {
                            eval($(this).data(origClickEventKey));
                        } else {
                            if (!$(messageBoxId).length) {
                                $('body').append('<div id="' + messageBoxId.substring(1) + '"></div>');
                            }
                            $(messageBoxId).html(msgBox);
                        }
                    });
                }
            });
        }
    }
})(jQuery, alv.util, alv.validators);