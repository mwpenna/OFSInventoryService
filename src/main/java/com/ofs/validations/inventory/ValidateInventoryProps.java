package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.model.Props;
import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.errors.ServerException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validations.InventoryUpdateValidation;
import com.ofs.validations.props.ValidatePropValue;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@Slf4j
public class ValidateInventoryProps implements InventoryCreateValidation, InventoryUpdateValidation {

    @Autowired
    private TemplateRepository templateRepository;

    @Autowired
    private ValidatePropValue validatePropValue;

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Optional<Template> templateOptional = templateRepository.getTemplateByName(inventory.getType(), inventory.getCompanyId());

        inventory.getProps().forEach(props -> {
            validatePropValue(props, errors);
        });

        if(templateOptional.isPresent()) {
            Template template = templateOptional.get();

            template.getProps().forEach(prop -> {
                Optional<Props> propsOptional = inventory.getProps().stream().filter(inventoryProp ->  inventoryProp.getName().equalsIgnoreCase(prop.getName())).findFirst();

                if(propsOptional.isPresent()) {
                    defaultSystemProps(propsOptional.get(), prop);
                }
                else {
                    if(prop.isRequired()) {
                        errors.rejectValue("inventory.required.prop.missing", "Validation error. Missing required template property.");

                    }
                }
            });

            inventory.getProps().forEach(prop -> {
                Optional<Props> propsOptional = template.getProps().stream().filter(templateProp -> templateProp.getName().equalsIgnoreCase(prop.getName())).findFirst();

                if(!propsOptional.isPresent()) {
                    errors.rejectValue("inventory.invalid.prop", "Validation error. Invalid property provided.");
                }
            });
        }
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
            log.error("Unhandled exception occurred");
            throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
