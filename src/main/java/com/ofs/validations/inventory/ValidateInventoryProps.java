package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.model.Props;
import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class ValidateInventoryProps implements InventoryCreateValidation {

    @Autowired
    private TemplateRepository templateRepository;

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Optional<Template> templateOptional = templateRepository.getTemplateByName(inventory.getType(), inventory.getCompanyId());

        if(templateOptional.isPresent()) {
            Template template = templateOptional.get();

            template.getProps().forEach(prop -> {
                if(prop.isRequired()) {
                    Optional<Props> propsOptional = inventory.getProps().stream().filter(inventoryProp ->  inventoryProp == prop).findFirst();

                    if(!propsOptional.isPresent()) {
                        errors.rejectValue("inventory_required_prop_missing", "Validation error. Missing required template property.");
                    }
                }
            });
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
