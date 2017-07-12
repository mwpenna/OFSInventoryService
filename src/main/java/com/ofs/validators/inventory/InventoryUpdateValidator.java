package com.ofs.validators.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.errors.BadRequestException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validations.InventoryUpdateValidation;
import com.ofs.validators.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class InventoryUpdateValidator implements Validator<Inventory> {

    private final List<InventoryUpdateValidation> VALIDATIONS = new ArrayList<>();

    @Autowired
    public InventoryUpdateValidator(List<InventoryUpdateValidation> validations) {
        validations.forEach(validation ->
                VALIDATIONS.add(validation)
        );
    }

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        for (InventoryUpdateValidation validation : VALIDATIONS) {
            validation.validate(inventory, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        for (InventoryUpdateValidation validation : VALIDATIONS) {
            validation.validate(changeSet, inventory, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }
}
