package com.aymhce.demo.api;

import com.aymhce.demo.entity.Person;
import com.aymhce.demo.repository.PersonRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/persons")
public class PersonController {

    private final PersonRepository personRepository;

    public PersonController(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    @GetMapping
    public List<Person> getAllPersons() {
        return personRepository.findAll();
    }

    @PostMapping
    public Person createPerson(@RequestBody Person person) {
        return personRepository.save(person);
    }

    @GetMapping("/{id}")
    public Person getPersonById(@PathVariable Long id) {
        return personRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Person not found with id " + id));
    }

    @PutMapping("/{id}")
    public Person updatePerson(@PathVariable Long id, @RequestBody Person personDetails) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Person not found with id " + id));
        person.setFirstName(personDetails.getFirstName());
        person.setLastName(personDetails.getLastName());
        return personRepository.save(person);
    }

    @PatchMapping("/{id}")
    public Person partialUpdatePerson(@PathVariable Long id, @RequestBody Person personDetails) {
        Person person = personRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Person not found with id " + id));
        if (personDetails.getFirstName() != null) {
            person.setFirstName(personDetails.getFirstName());
        }
        if (personDetails.getLastName() != null) {
            person.setLastName(personDetails.getLastName());
        }
        return personRepository.save(person);
    }

    @DeleteMapping("/{id}")
    public void deletePerson(@PathVariable Long id) {
        personRepository.deleteById(id);
    }

}