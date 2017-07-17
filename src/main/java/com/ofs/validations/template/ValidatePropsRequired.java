package com.ofs.validations.template;

import com.ofs.model.Props;
import com.ofs.model.Template;
import com.ofs.server.errors.ServerException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.service.InventoryService;
import com.ofs.validations.TemplateUpdateValidation;
import com.ofs.validations.props.ValidatePropValue;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Component
public class ValidatePropsRequired implements TemplateUpdateValidation {
    @Autowired
    private ValidatePropValue validatePropValue;

    @Autowired
    private InventoryService inventoryService;

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        Map<String, Props> previousPropMap = template.getPreviousProps().stream().collect(Collectors.toMap(Props::getName, Props::getProp));

        template.getProps().forEach(props -> {
            if(isNewProp(props, previousPropMap)) {
                if(!isDefaultValueMissing(props, errors)) {
                    validatePropValue(props, errors);
                }
            }
        });

        updateInventoryProps(template, errors);
    }

    private boolean isNewProp(Props props, Map<String, Props> previousPropMap) {
        return props.isRequired() && !previousPropMap.containsKey(props.getName());
    }

    private boolean isDefaultValueMissing(Props props, OFSErrors errors) {
        if(props.getDefaultValue() == null || props.getDefaultValue().isEmpty()) {
            OFSError error = errors.rejectValue("template.props.default_value.required_field_missing", "Validation error. Cannot update template with required prop {name} without providing default value.");
            error.put("name", props.getName());
            return true;
        }

        return false;
    }

    private void validatePropValue(Props props, OFSErrors errors) {
        try {
            validatePropValue.validate(props, errors);
        } catch (Exception e) {
            log.error("Unhandled exception occurred");
            throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private void updateInventoryProps(Template template, OFSErrors errors) {
        if(errors.isEmpty()) {
            try {
                inventoryService.updateInventoryProps(template);
            } catch (Exception e) {
                log.error("Unhandled exception occurred when trying to update inventory props", e);
                throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        if(changeSet.contains("props")) validate(template, errors);
    }
}
