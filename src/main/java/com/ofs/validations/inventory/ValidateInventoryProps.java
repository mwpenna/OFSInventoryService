package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.model.Props;
import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.errors.ServerException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validations.InventoryUpdateValidation;
import com.ofs.validations.props.ValidatePropValue;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@Slf4j
public class ValidateInventoryProps implements InventoryCreateValidation, InventoryUpdateValidation {

    @Autowired
    private TemplateRepository templateRepository;

    @Autowired
    private ValidatePropValue validatePropValue;

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {

        if(inventory.getType().equalsIgnoreCase("DEFAULT")) {
            validateDefaultProps(inventory, errors);
        }

        Optional<Template> templateOptional = templateRepository.getTemplateByName(inventory.getType(), inventory.getCompanyId());

        if(templateOptional.isPresent()) {
            Template template = templateOptional.get();
            validateAllRequiredPropsPresent(inventory, template, errors);
            validateInventoryPropInTemplate(inventory, template, errors);

            if(errors.isEmpty()) {
                validateInventoryPropValue(inventory, template, errors);
            }
        }
    }

    private void validateDefaultProps(Inventory inventory, OFSErrors errors) {
        if(inventory.getProps() != null && !inventory.getProps().isEmpty()) {
            errors.rejectValue("inventory.props.not_acceptable","Validation error. Cannot create/update inventory props when inventory type is DEFAULT.");
        }
    }

    private void validateInventoryPropValue(Inventory inventory, Template template, OFSErrors errors) {
        Map<String, Props> propMap = template.getProps().stream().collect(Collectors.toMap(Props::getName, Props::getProp));

        inventory.getProps().forEach(props -> {
            props.setType(propMap.get(props.getName()).getType());
            validatePropValue(props, errors);
        });
    }

    private void validateAllRequiredPropsPresent(Inventory inventory, Template template, OFSErrors errors) {
        template.getProps().forEach(prop -> {
            Optional<Props> propsOptional = inventory.getProps().stream().filter(inventoryProp ->  inventoryProp.getName().equalsIgnoreCase(prop.getName())).findFirst();

            if(propsOptional.isPresent()) {
                defaultSystemProps(propsOptional.get(), prop);
            }
            else {
                if(prop.isRequired()) {
                    OFSError error = errors.rejectValue("inventory.required.prop.missing", "Validation error. Missing required template property.");
                    error.put("name", prop.getName());
                }
            }
        });
    }

    private void validateInventoryPropInTemplate(Inventory inventory, Template template, OFSErrors errors) {
        inventory.getProps().forEach(prop -> {
            Optional<Props> propsOptional = template.getProps().stream().filter(templateProp -> templateProp.getName().equalsIgnoreCase(prop.getName())).findFirst();

            if(!propsOptional.isPresent()) {
                errors.rejectValue("inventory.invalid.prop", "Validation error. Invalid property provided.");
            }
        });
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }

    private void defaultSystemProps(Props inventoryProp, Props templateProp) {
        inventoryProp.setRequired(templateProp.isRequired());
        inventoryProp.setType(templateProp.getType());
    }

    private void validatePropValue(Props props, OFSErrors errors) {
        try {
            validatePropValue.validate(props, errors);
        } catch (Exception e) {
            log.error("Unhandled exception occurred", e);
            throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
