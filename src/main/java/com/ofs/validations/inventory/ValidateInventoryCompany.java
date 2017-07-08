package com.ofs.validations.inventory;

import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validations.InventoryCompanyValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateInventoryCompany implements InventoryCompanyValidation {
    @Override
    public void validate(String companyId, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN")){
            if(!companyId.equalsIgnoreCase(StringUtils.getIdFromURI(subject.getCompanyHref()))){
                throw new UnauthorizedException("OAuth", "OFSServer");
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, String companyId, OFSErrors errors) throws Exception {
        validate(companyId, errors);
    }
}
