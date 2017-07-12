package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryUpdateValidation;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ValidateInventoryDuplicateProps implements InventoryUpdateValidation{

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        inventory.getProps().forEach(prop -> {
            List inventoryList = inventory.getProps().stream().filter(inventoryProp ->  inventoryProp.getName().equalsIgnoreCase(prop.getName())).collect(Collectors.toList());

            if(inventoryList.size()>1) {
                OFSError error = errors.rejectValue("inventory.props.name.duplicate", "Invalid prop with name: {name}. Prop list contained multiple prop elements with the same name.");
                error.put("name" , prop.getName());
            }
        });
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
