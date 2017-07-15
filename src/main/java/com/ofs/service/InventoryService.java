package com.ofs.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ofs.model.Inventory;
import com.ofs.model.Props;
import com.ofs.model.Template;
import com.ofs.repository.InventoryRepository;
import com.ofs.server.errors.ServerException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@Slf4j
public class InventoryService {

    @Autowired
    private InventoryRepository inventoryRepository;

    public void updateInventoryProps(Template template) throws Exception {
        Optional<List<Inventory>> inventoryListOptional= inventoryRepository.getInventoryByType(template.getCompanyId(), template.getName());

        if(inventoryListOptional.isPresent()) {
            List<Inventory> inventoryList = inventoryListOptional.get();

            inventoryList.forEach(inventory -> {
                defaultPropIfPropDNE(template, inventory);
                updateInventoryForTemplate(inventory, template);
            });
        }
    }

    private void defaultPropIfPropDNE(Template template, Inventory inventory) {
        Map<String, Props> propMap = getPropsAsMap(inventory.getProps());

        getRequiredProps(template.getProps()).forEach(props -> {
            if(!propMap.containsKey(props.getName())) {
                props.setValue(props.getDefaultValue());
                inventory.getProps().add(props);
            }
        });
    }

    private void updateInventoryForTemplate(Inventory inventory, Template template) {
        try {
            inventoryRepository.updateInventory(inventory);
        } catch (JsonProcessingException e) {
            log.error("Error updating inventory with id: {} for updated template ({})", inventory.getId(), template.getId(), e);
            throw new ServerException(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private List<Props> getRequiredProps(List<Props> propsList) {
        return propsList.stream().filter(props -> props.isRequired()).collect(Collectors.toList());
    }

    private Map<String, Props> getPropsAsMap(List<Props> propsList) {
        return propsList.stream().collect(Collectors.toMap(Props::getName, Props::getProp));
    }
}
