package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.validations.InventorySearchValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateInventorySearch implements InventorySearchValidation{
    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") && !subject.getRole().equalsIgnoreCase("ADMIN") && !subject.getRole().equalsIgnoreCase("ACCOUNT_MANAGER")) {
            throw new UnauthorizedException("OAuth", "OFSServer");
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
