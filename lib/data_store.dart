import 'package:flutter/material.dart';

class DataStore with ChangeNotifier {
  Map? userData;

  DataStore({this.userData});

  Map? get chewData => userData;
  Map? get patientData => userData;
  Map? get doctorData => userData;

  Map<String, dynamic> addCaseData = {
    'maleOrFemale': null,
    'stage1Tap': null,
    'caseData': null,
    'headings': {
      'Neck': {
        'whiteButtons': ['Anterior Neck', 'Posterior Neck']
      },
      'Anterior Neck': {
        'greyList': [
          "Neck Pain",
          "Arthritis",
          "Swollen Neck",
          "Torticollis",
          "Thyroid Disorders",
          "Muscle Strain",
          "Meningitis",
          "Influenza",
          "Lung Infection"
        ],
      },
      'Posterior Neck': {
        'greyList': [
          "Neck Pain",
          "Arthritis",
          "Swollen Neck",
          "Torticollis",
          "Thyroid Disorders",
          "Muscle Strain",
          "Meningitis",
          "Influenza",
          "Lung Infection"
        ],
      },
      'Head': {
        'whiteButtons': ['Forehead', 'Eye', 'Mouth', 'Nose', 'Ear']
      },
      'Eye': {
        'greyList': [
          'Cataracts',
          'Colour blindness',
          'Dry Eye',
          'Glaucoma',
          'Eye Infection'
        ]
      },
      'Forehead': {
        'greyList': [
          'Headache',
          'Tension Headache',
          'Migraine Headache',
          'Cluster Headache',
          'Sinus Headache',
          'Posttraumatic Headache'
        ]
      },
      'Mouth': {
        'greyList': ['Lip Crack', 'Ulcer', 'Toothache', 'Bad Breath'],
      },
      'Nose': {
        'greyList': [
          'Runny Nose',
          'Nasal Congestion',
          'Nosebleed',
          'Sinus Pain'
        ]
      },
      'Ear': {
        'greyList': [
          'Earwax Build-up',
          'Ear Infection',
          'Hearing Loss',
          'Tinnitus'
        ]
      },
      'Chest': {
        'greyList': [
          'Stomach Pain',
          'Abdominal Pain',
          'Stomach Ulcer',
          'Gastroparesis',
          'Diabetic',
          'Chest Pain'
        ]
      },
      'Leg': {
        'greyList': [
          'Numbness',
          'Cramps',
          'Sprains',
          'Pain',
          'Swelling',
          'Joint Dislocation',
          'Cracked skin',
          'Callus',
          'Foot Complications'
        ]
      },
      'Hand': {
        'greyList': [
          'Fracture',
          'Muscle Strain',
          'Sprains',
          'Inflamed tendor',
          'Swelling',
          'Joint dislocation'
        ]
      },
      'Shoulder': {
        'greyList': [
          'Fracture',
          'Dislocation',
          'Sprains',
          'Impengement',
          'Separation'
        ]
      },
      'Dorsum': {
        'greyList': [
          'Back Pain',
          'Acute Back Pain',
          'Arthritis',
          'Low Back Pain'
        ]
      },
    },
    'questionnaire': {
      'Chest Pain': {
        "Have you been told you have an abnormal ECG?": ["Yes", "No"],
        "Do you have chest pain with walking/normal activity or exercise?": [
          "Yes",
          "No"
        ],
        "Are you been treated for high blood pressure?": ["Yes", "No"],
        "Do you have a cardiologist?": ["Yes", "No"],
        "If yes, do they know about your current circumstance?": ["Yes", "No"],
        "Do you have pulmonary hypertension?": ["Yes", "No"],
        "Do you have a heart murmur, mitral valve prolapse?": ["Yes", "No"],
        "Have you had a heart attack before?": ["Yes", "No"],
        "Have you ever had a stress test before?": ["Yes", "No"]
      },
      'Eye Infection': {
        "Do you Wear Glasses?": ["Yes", "No"],
        "Do you Wear Contact lens?": ["Yes", "No"],
        "Do you have difficulty, even with Glasses with the following activities? Reading small prints?":
            ["Yes", "No"],
        "If yes, how much difficulty do you currently have?": [
          "A little",
          "A great deal",
          "Unable to do any activity",
          "A moderate amount"
        ],
        "Are you using any regular eye drops?": ["Yes", "No"],
        "For How long?": ["Over a Week", "Over a Month"],
        "Do you smoke": ["Yes", "No"],
        "Do you take alcohol": ["Yes", "No"]
      },
      'Migraine Headache': {
        "When did your Migraine begin?": [
          "Some days ago",
          "Few weeks ago",
          "Months",
          "Been Years"
        ],
        "Have you had a head injury before?": ["Yes", "No"],
        "How painful is your Migraine?": ["Mild", "Severe"],
        "How would you describe your Migraine headache?": [
          "Throbbing/Pounding",
          "Aching/Pounding"
        ],
        "Did the Botox treatment work?": ["Yes", "No"],
        "For How long?": ["Over a Week", "Over a Month"],
        "Are you taking any prescription drugs to treat your Migraine?": [
          "Yes",
          "No"
        ],
        "Are you taking any Over the counter drugs to treat your Migraine?": [
          "Yes",
          "No"
        ]
      },
      'Stomach Pain': {
        "Are you experiencing stomach pain?": ["Yes", "No"],
        "Do you have abdominal pain?": ["Yes", "No"],
        "Are you experiencing heart burn?": ["Yes", "No"],
        "Do you excrete black poop?": ["Yes", "No"],
        "Are you stooling?": ["Yes", "No"],
        "Does one of your family have history of Ulcer?": ["Yes", "No"],
        "How many meals can you cover a day?": ["Over a Week", "Over a Month"],
        "Are you taking any prescription drugs to treat your Ulcer?": [
          "Yes",
          "No"
        ],
        "Are you taking any Over the counter drugs to treat your Ulcer?": [
          "Yes",
          "No"
        ]
      }
    }
  };

  void updateChewData(Map? newValue) {
    userData = newValue;
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

  void updateCase(int index, Map updates) {
    if (userData != null && userData?['cases'] != null) {
      userData?['cases'][index] = {...userData?['cases'][index], ...updates};
    }
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
