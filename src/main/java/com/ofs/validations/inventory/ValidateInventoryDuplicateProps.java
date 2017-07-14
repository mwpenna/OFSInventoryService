package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validations.InventoryUpdateValidation;
import com.ofs.validations.props.ValidateDuplicateProps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ValidateInventoryDuplicateProps implements InventoryUpdateValidation, InventoryCreateValidation{

    @Autowired
    ValidateDuplicateProps validateDuplicateProps;

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        validateDuplicateProps.validate(inventory.getProps(), errors);
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
