package edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.transformations.ejbmapping.java2pcm.change2commandtransforming

import edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.seffstatements.code2seff.Java2PcmMethodBodyChangePreprocessor
import edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.transformations.ejbmapping.java2pcm.seff.EJBJava2PCMCode2SEFFFactory
import mir.responses.AbstractChange2CommandTransformingJavaTo5_1
import edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.transformations.packagemapping.util.Java2PcmPackagePreprocessor
import edu.kit.ipd.sdq.vitruvius.casestudies.pcmjava.transformations.ejbmapping.java2pcm.TUIDUpdatePreprocessor

class Change2CommandTransformingEJBJavaToPCM extends AbstractChange2CommandTransformingJavaTo5_1 {
	public new() {
		super();
		addPreprocessor(new TUIDUpdatePreprocessor());
		addPreprocessor(new Java2PcmPackagePreprocessor());  
		addPreprocessor(new Java2PcmMethodBodyChangePreprocessor(new EJBJava2PCMCode2SEFFFactory));
		// TODO HK Replace this preprocessor with a generic mechanism in the change synchronizer
	}
}