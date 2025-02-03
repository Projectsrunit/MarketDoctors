import 'package:flutter/material.dart';

class DataStore with ChangeNotifier {
  Map? userData;

  DataStore({this.userData});

  Map? get chewData => userData;
  Map? get patientData => userData;
  Map? get doctorData => userData;
  List<String> tempSymptoms = [];
  int? updatingId;

  Map<String, Map<String, dynamic>> addCaseData = {
    'caseData': {},
    'caseVisitData': {},
    'pictures': {
      'Head': 'assets/images/head.png',
      'Chest': 'assets/images/chest.png',
      'Stomach': 'assets/images/stomach.png',
      'Skin': 'assets/images/skin.png',
      'General': 'assets/images/general.png'
    },
    'symptoms': {
      'Head': {
        'Infections and Diseases': [
          'Ear Infections',
        ],
        'Respiratory Issues': [
          'Common Cold',
          'Sinusitis',
          'Sore Throat',
        ],
        'Others': [
          'Headaches',
          'Dental Pain',
          'Tooth cavity',
          'Gum infection',
          'Pink eye',
          'Glaucoma',
          'Migraines',
        ],
      },
      'Chest': {
        'Respiratory Issues': [
          'Asthma',
          'Bronchitis',
        ],
        'Others': [
          'Allergic Reactions',
        ],
      },
      'Stomach': {
        'Infections and Diseases': [
          'Malaria',
          'Typhoid',
          'Acute Food Poisoning',
          'Roundworms',
          'Hookworms',
          'Tapeworms',
        ],
        'Digestive Health': [
          'Diarrhea',
          'Ulcers',
          'Bloating',
          'Constipation',
        ],
      },
      'Skin': {
        'Skin Conditions': [
          'Bacterial Skin Infection',
          'Boils',
          'Leprosy',
          'Fungal Skin Infections',
          'Ringworm',
          'Athlete\'s Foot',
          'Scabies',
        ],
      },
      'General': {
        'Musculoskeletal': [
          'Arthritis',
          'Back Pain',
          'Lower Back Pain',
        ],
        'Others': [
          'Type 2 Diabetes',
          'Anemia',
          'Menstrual Pain',
          'Urinary Tract Infections',
          'Gonorrhea',
          'Chlamydia',
          'Vaginal Infections',
          'Bacterial Vaginosis',
          'Yeast Infections',
          'Fever',
        ],
      },
    }
  };

  void updateChewData(Map? newValue) {
    userData = newValue;
    notifyListeners();
  }

  void setUpdatingId(int? fig) {
    updatingId = fig;
    notifyListeners();
  }

  void removePayment(int index) {
    if (userData != null && userData?['payments'] != null) {
      userData?['payments'].removeAt(index);
      notifyListeners();
    }
  }

  void addPayment(Map payment) {
    if (userData != null) {
      if (userData!['payments'] == null) {
        userData!['payments'] = [];
      }
      userData!['payments'].add(payment);
      notifyListeners();
    }
  }

  void removeCase(int index) {
    if (userData != null && userData?['cases'] != null) {
      userData?['cases'].removeAt(index);
      notifyListeners();
    }
  }

  void updateCase(int index, List updates) {
    if (userData != null && userData?['cases'] != null) {
      userData?['cases'][index]['casevisits'] = updates;
    }
  }

  void changeTheCaseData(Map<String, dynamic> newData) {
    addCaseData = {...addCaseData, 'caseData': newData};
    notifyListeners();
  }

  void changeTheCaseVisitData(Map<String, dynamic> newData) {
    addCaseData = {...addCaseData, 'caseVisitData': newData};
    notifyListeners();
  }

  void updateCaseSymptom(List<String> newData) {
    tempSymptoms = newData;
    notifyListeners();
  }

  void addCase(Map newCase) {
    if (userData != null) {
      if (userData!['cases'] == null) {
        userData!['cases'] = [];
      }
      userData!['cases'].add(newCase);
      notifyListeners();
    }
  }

  void editCase(int caseId, Map newVisit) {
    print('matching to check for id $caseId');
    if (userData != null && userData!['cases'] != null) {
      for (var c in userData!['cases']) {
        print('this id is ${c['id']}');
        if (c['id'] == caseId) {
          print('found it.');
          print('new visit is $newVisit and current visit ======= ${c['casevisits']}');
          c['casevisits'] ??= [];
          c['casevisits'].add(newVisit);
          notifyListeners();
          break;
        }
      }
    }
  }

  void updatePatientData(Map? newValue) {
    userData = newValue;
    notifyListeners();
  }

  void updateDoctorData(Map? newValue) {
    userData = newValue;

    notifyListeners();
  }

  void setDoctorData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }
}
