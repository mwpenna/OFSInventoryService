package com.ofs.validations.template;

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

@Slf4j
public class ValidatePropsRequired implements TemplateUpdateValidation {
    @Autowired
    private ValidatePropValue validatePropValue;

    @Autowired
    private InventoryService inventoryService;

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        template.getProps().forEach(props -> {
            if(props.isRequired()) {
                if(props.getDefaultValue().isEmpty()) {
                    OFSError error = errors.rejectValue("template.props.default_value.required_field_missing", "Validation error. Cannot update template with required prop {name} without providing default value.");
                    error.put("name", props.getName());
                }
                else {
                    try {
                        validatePropValue.validate(props, errors);
                    } catch (Exception e) {
                        log.error("Unhandled exception occurred");
                        throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
                    }

                    if(errors.isEmpty()) {
                        try {
                            inventoryService.updateInventoryProps(template);
                        } catch (Exception e) {
                            log.error("Unhandled exception occurred when trying to update inventory props", e);
                            throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
                        }
                    }
                }
            }
        });
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        if(changeSet.contains("props")) {
            validate(template, errors);
        }
    }
}
