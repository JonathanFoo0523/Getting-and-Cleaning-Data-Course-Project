# Codebook



## Transformation
I have done several transformation to clean up the data:

1. The activity label is reassign from integer representing the activity to the actual name of the avtivity.
2. The activity name is reformatted to be lowercased and not having special character like `_`
3. The variable label is reformatted such that there are no special characte like `-` or `.` which might be a problem when storing the new data in certain database. Additionally, the name of the variable is kept as short and descriptive as possible.


## Data
The dataset adhered to the [tidy data principle](https://vita.had.co.nz/papers/tidy-data.pdf), namely:

* Each observation must have its own row
* Each variable must have its own column
* Each type of observational unit forms a table.


## Variables

#### Independent Variables 
| Variable        | Description                 |
| ------ |:----------------------|
| Subject    | Represent the identity of participants of the experiment. There are 30 participants, labelled from 1 to 30 |
| Activity   | Activity carried out for the experiment. Each person performed six activities (walking, walking upstair, walking downstair, sitting, standing, laying) |
  
#### Measurement Variables
The measurement variables in dataset follow the following convention:
```
{Domain}{listOfComponets}{Optional: Dimension}{typeOfMeasurement}
```
and a camel case convention is used to separate those componets.

### Domain
| Token        | Description                 |
| ------ |:----------------------|
| t    | Represent time domain signals. These signals are captured at constant rate of 50Hz and then processed to remove noise |
| f    | Represent frequency domain signals. These features are produced when Fast Fourier Transform is applied to time domain signal |

### Components
| Token  | Desctiption          |
| ------ | :------------------- |
| Body    | Signal based on the body of an experiment participants, one of two components derived from the time based signals on the phone's sensor |
| Gravity | Signal based on gravity, the force that attracts a body towars the center of the earth. Gravity is the second components derived from the time based signals on the phone's sensor |
| Acc     | Represent linear acceleration. Feature that come from or derived from accelerometer. |
| Gyro    | Repersent angular velocity. Feature that come from or derived from gyroscope |
| Jerk    | {components}Jerk represent the time derivative of {components} |
| Mag     | Represent Magnitude. Calculated using the Euclidean norm. |

### Dimension
Can be `X` or `Y` or `Z` or no value(optional). The data from sensor are recorded as 3-axial raw signals.

### typeOfMeasurement
| Token        | Description                 |
| ------ |:----------------------|
| Mean    | Average |
| Sd    | Standard deviation |
