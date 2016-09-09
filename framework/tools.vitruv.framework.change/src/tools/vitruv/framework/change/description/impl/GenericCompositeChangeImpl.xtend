package tools.vitruv.framework.change.description.impl

import java.util.List
import java.util.LinkedList
import tools.vitruv.framework.change.description.GenericCompositeChange
import tools.vitruv.framework.change.echange.EChange
import java.util.ArrayList
import tools.vitruv.framework.change.description.VitruviusChange

abstract class GenericCompositeChangeImpl<C extends VitruviusChange> implements GenericCompositeChange<C> {
    List<C> changes;

    new() {
        this.changes = new LinkedList<C>();
    }

    new(List<? extends C> changes) {
        this.changes = new LinkedList<C>(changes);
    }

    override List<C> getChanges() {
        return new LinkedList<C>(this.changes);
    }

    override addChange(C change) {
		if (change != null && !(change instanceof EmptyChangeImpl)) this.changes.add(change);
    }
				
	override containsConcreteChange() {
		var containsConcreteChange = false;
		for (change : changes) {
			if (change instanceof GenericCompositeChange<?>) {
				containsConcreteChange = containsConcreteChange || change.containsConcreteChange();
			} else {
				containsConcreteChange = containsConcreteChange || true;
			}
		}
		return containsConcreteChange;
	}
	
	override getURI() {
		if (changes.empty) {
			return null;
		} else {
			return changes.get(0).URI;
		}
	}
	
	override validate() {
		if (!this.containsConcreteChange()) {
			return false;
		}

		var lastURI = changes.get(0).URI;
		for (change : changes) {
			if (change.URI != lastURI) {
				return false;
			}
			lastURI = change.URI;
		}
		return true;
	}
	
	override getEChanges() {
		return changes.fold(new ArrayList<EChange>(), 
			[eChangeList, change | 
				eChangeList.addAll(change.EChanges);
				return eChangeList;
			]
		);
	}
	
}
