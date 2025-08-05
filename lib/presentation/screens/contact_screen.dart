import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../core/data/models/contact_item.dart';
import '../../core/data/providers/contact_provider.dart';
import '../widgets/back_button_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationController = TextEditingController();

  String? _editingId;

  void _saveContact() {
    if (!_formKey.currentState!.validate()) return;

    final contact = ContactItem(
      id: _editingId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      relation: _relationController.text.trim(),
    );

    final provider = Provider.of<ContactProvider>(context, listen: false);

    if (_editingId == null) {
      provider.addContact(contact);
    } else {
      provider.updateContact(contact);
    }

    _resetForm();
  }

  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _relationController.clear();
    });
  }

  void _editContact(ContactItem contact) {
    setState(() {
      _editingId = contact.id;
      _nameController.text = contact.name;
      _phoneController.text = contact.phone;
      _emailController.text = contact.email;
      _relationController.text = contact.relation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactProvider>().contacts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Personne à prévenir'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Champ requis' : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Téléphone'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _relationController,
                    decoration: const InputDecoration(labelText: 'Relation'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _saveContact,
                    icon: const Icon(Icons.save),
                    label: Text(_editingId == null ? 'Ajouter' : 'Mettre à jour'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: contacts.isEmpty
                  ? const Center(child: Text('Aucun contact enregistré'))
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          title: Text(contact.name),
                          subtitle: Text(
                              '${contact.relation} — ${contact.phone} — ${contact.email}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _editContact(contact),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => Provider.of<ContactProvider>(context,
                                        listen: false)
                                    .deleteContact(contact.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
