%module ConsensusCore2

// for the 309 warning about boost::noncoypable, try to figure out %ignore
#pragma SWIG nowarn=309

%{
#define SWIG_FILE_WITH_INIT
%}

%ignore *::operator[];
%ignore *::operator=;
%ignore *::operator<<;
%ignore *::operator std::tuple<bool&, size_t&, size_t&>;
%ignore *::operator std::string;

%include <exception.i>
%include <std_pair.i>
%include <std_set.i>
%include <std_string.i>
%include <std_vector.i>
%include <stdint.i>

#ifdef SWIGPYTHON
%include "numpy.i"
#endif

// generic exception handling
%exception {
    try
    { $action }
    catch (const std::exception& e)
    { SWIG_exception(SWIG_RuntimeError, e.what()); }
}

namespace std
{
    // pair types
    %template(DoublePair) std::pair<double, double>;
    %template(IntPair) std::pair<int, int>;
    %template(LengthPair) std::pair<size_t, size_t>;

    %apply const pair<double, double>& {pair<double, double>*};
    %apply const pair<int, int>& {pair<int, int>*};
    %apply const pair<size_t, size_t>& {pair<size_t, size_t>*};

    // set types
    %template(StringSet) std::set<std::string>;

    %apply const set<string>& {set<string>*};

    // vector types
    %template(DoubleVector) std::vector<double>;
    %template(IntPairVector) std::vector<std::pair<int, int> >;
    %template(IntVector) std::vector<int>;
    %template(StringVector) std::vector<string>;
    %template(Uint8Vector) std::vector<uint8_t>;

    %apply const vector<double>& {vector<double>*};
    %apply const vector<pair<int, int> >& {vector<pair<int, int> >*};
    %apply const vector<int>& {vector<int>*};
    %apply const vector<string>& {vector<string>*};
    %apply const vector<uint8_t>& {vector<uint8_t>*};
}

%define py_tp_str(cls)
%#ifdef SWIGPYTHON
%feature("python:slot", "tp_str", functype="reprfunc") cls::as_string();
%extend cls { std::string as_string() { return std::string(*$self); } }
%#endif // SWIGPYTHON
%enddef

// no include dependencies
%include "State.i"
%include "Alignment.i"
%include "Coverage.i"
%include "Matrix.i"
%include "ModelConfig.i"
%include "Mutation.i"
%include "Polish.i"
%include "Read.i"
%include "Version.i"

// after ModelConfig.i and Mutation.i
// %include "Template.i"

// after Read.i
%include "Evaluator.i"
%include "Integrator.i"
%include "Poa.i"

%init
%{
#ifdef SWIGPYTHON
  import_array();
#endif // SWIGPYTHON
%}
