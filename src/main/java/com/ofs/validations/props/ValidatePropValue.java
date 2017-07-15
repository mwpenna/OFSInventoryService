package com.ofs.validations.props;

import com.ofs.model.Props;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.validators.Validator;
import org.springframework.stereotype.Component;

@Component
public class ValidatePropValue implements Validator<Props> {
    @Override
    public void validate(Props props, OFSErrors errors) throws Exception {
        switch (props.getType()) {
            case NUMBER:
                evaluateNumber(props, errors);
                break;

            case BOOLEAN:
                evaluateBoolean(props, errors);
                break;

            case STRING:
                evaluateString(props, errors);
                break;
        }
    }

    private void evaluateNumber(Props prop, OFSErrors errors) {
        if(!validateNumber(prop.getValue() != null ? prop.getValue() : prop.getDefaultValue())) {
            generateInvalidError(prop, errors);
        }
    }

    private void evaluateBoolean(Props prop, OFSErrors errors) {
        if(!validateBoolean(prop.getValue() != null ? prop.getValue() : prop.getDefaultValue())) {
            generateInvalidError(prop, errors);
        }
    }

    private void evaluateString(Props prop, OFSErrors errors) {

    }

    private void generateInvalidError(Props prop, OFSErrors errors) {
        OFSError error = errors.rejectValue("prop.invalid_value", "Validation exception. Invalid prop value: {value} for type: {type}.");
        error.put("value", prop.getValue() != null ? prop.getValue() : prop.getDefaultValue()).put("type", prop.getType().toString());
    }

    private boolean validateNumber(String value) {
        try {
            Float.parseFloat(value);
            return true;
        }
        catch(NumberFormatException ex) {
            return false;
        }
    }

    private boolean validateBoolean(String value) {
        if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
            return true;
        }

        return false;
    }

    @Override
    public void validate(ChangeSet changeSet, Props props, OFSErrors errors) throws Exception {
        validate(props, errors);
    }
}
