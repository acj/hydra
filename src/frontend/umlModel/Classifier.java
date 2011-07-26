package frontend.umlModel;

import java.util.Comparator;
import java.util.TreeMap;

/** @modelguid {D5AF7102-5B96-49F2-AF2D-A478E8DCB002} */
public abstract class Classifier extends GeneralizableElement {
	/**
	 * @modelguid {699EC15D-5D61-40B5-884D-ED37E026A4D9}
	 */
	public java.util.TreeMap feature;

	/** @modelguid {111809C4-D326-4996-8B94-7DA8FC2B4E25} */
	public Classifier() {
		feature = new TreeMap(new FeatureComparator());
	}

	// Used to sort the features of a classifier correctly
	/** @modelguid {0B6E3D6C-30C8-445F-B1A9-AE8D34D6448F} */
	class FeatureComparator implements Comparator {
		/** @modelguid {A1E822DB-CCB9-4CDD-8FC0-8E2B534D6411} */
		public int compare(Object a, Object b) {
			// We want to have fields first, then operations
			if (a instanceof StructuralFeature && b instanceof BehavioralFeature) {
				return -1;
			}

			if (a instanceof BehavioralFeature && b instanceof StructuralFeature) {
				return 1;
			}

			// Ok, now we got here, meaning we got two of the same type. We will just compare them by name
			Feature fa = (Feature) a;
			Feature fb = (Feature) b;

			return fa.name.compareToIgnoreCase(fb.name);
		}
	}

}