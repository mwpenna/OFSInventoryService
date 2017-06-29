package com.ofs.validations.template;

import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.validations.TemplateDeleteValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateDeletePermissions implements TemplateDeleteValidation {
    @Override
    public void validate(String id, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") && !subject.getRole().equalsIgnoreCase("ADMIN")) {
            throw new UnauthorizedException("OAuth", "OFSServer");
        }
    }

    @Override
    public void validate(ChangeSet changeSet, String id, OFSErrors errors) throws Exception {
        validate(id, errors);
    }
}
